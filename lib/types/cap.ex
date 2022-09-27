defmodule Kadena.Types.Cap do
  @moduledoc """
  `Cap` struct definition.
  """
  alias Kadena.Types.PactValuesList

  @behaviour Kadena.Types.Spec

  @type name :: String.t()
  @type args :: PactValuesList.t() | list()
  @type pact_values :: PactValuesList.t()
  @type error :: Keyword.t()
  @type validation :: {:ok, any()} | {:error, error()}

  @type t :: %__MODULE__{name: name(), args: pact_values()}

  defstruct [:name, :args]

  @impl true
  def new(args) when is_list(args) do
    name = Keyword.get(args, :name)
    args = Keyword.get(args, :args)

    with {:ok, name} <- validate_name(name),
         {:ok, args} <- validate_args(args) do
      %__MODULE__{name: name, args: args}
    end
  end

<<<<<<< HEAD
  def new(_args), do: {:error, [args: :invalid]}
=======
  def new(_args), do: {:error, [args: :invalids]}
>>>>>>> a72e387 (Add Cap types)

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
end
