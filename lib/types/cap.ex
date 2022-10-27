defmodule Kadena.Types.Cap do
  @moduledoc """
  `Cap` struct definition.
  """
  alias Kadena.Types.PactValuesList

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type name :: String.t()
  @type args :: PactValuesList.t() | list()
  @type pact_values :: PactValuesList.t()
  @type error :: Keyword.t()
  @type validation :: {:ok, any()} | {:error, error()}

  @type t :: %__MODULE__{name: name(), args: pact_values(), json: json()}

  defstruct [:name, :args, :json]

  @impl true
  def new(args) when is_list(args) do
    name = Keyword.get(args, :name)
    args = Keyword.get(args, :args)

    with {:ok, name} <- validate_name(name),
         {:ok, args} <- validate_args(args),
         {:ok, json} <- to_json(name, args) do
      %__MODULE__{name: name, args: args, json: json}
    end
  end

  def new(_args), do: {:error, [args: :invalid]}

  @spec validate_name(name :: name()) :: validation()
  defp validate_name(name) when is_binary(name), do: {:ok, name}
  defp validate_name(_name), do: {:error, [name: :invalid]}

  @spec validate_args(args :: list()) :: validation()
  defp validate_args(args) when is_list(args) do
    case PactValuesList.new(args) do
      %PactValuesList{} = pact_values -> {:ok, pact_values}
      {:error, [{_arg, reason}]} -> {:error, [args: reason]}
    end
  end

  defp validate_args(%PactValuesList{} = pact_values), do: {:ok, pact_values}

  defp validate_args(_args), do: {:error, [args: :invalid]}

  @spec to_json(name :: name(), pact_values()) :: {:ok, json()}
  defp to_json(name, %PactValuesList{json: pact_values}) do
    %{name: name, args: "{args}"}
    |> Jason.encode!()
    |> String.replace("\"{args}\"", pact_values)
    |> (&{:ok, &1}).()
  end
end
