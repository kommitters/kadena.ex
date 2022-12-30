defmodule Kadena.Types.Cap do
  @moduledoc """
  `Cap` struct definition.
  """
  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type name :: String.t()
  @type pact_values :: list(PactValue.t())
  @type error :: Keyword.t()
  @type build_args :: pact_values() | {:error, error()}
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

  def new(args) when is_map(args) do
    name = Map.get(args, :name)
    args = Map.get(args, :args)

    with {:ok, name} <- validate_name(name),
         {:ok, args} <- validate_args(args) do
      %__MODULE__{name: name, args: args}
    end
  end

  def new(_args), do: {:error, [args: :invalid]}

  @spec validate_name(name :: name()) :: validation()
  defp validate_name(name) when is_binary(name), do: {:ok, name}
  defp validate_name(_name), do: {:error, [name: :invalid]}

  @spec validate_args(args :: list()) :: validation()
  defp validate_args([]), do: {:ok, []}
  defp validate_args(args) when is_list(args), do: build_list(PactValue.new(args))
  defp validate_args(_args), do: {:error, [args: :invalid]}

  @spec build_list(build_args()) :: validation()
  defp build_list(pact_value) when is_list(pact_value), do: {:ok, pact_value}
  defp build_list({:error, reason}), do: {:error, reason}
end
