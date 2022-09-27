defmodule Kadena.Types.Cap do
  @moduledoc """
  `Cap` struct definition.
  """

  alias Kadena.Types.PactValuesList

  @behaviour Kadena.Types.Spec

  @type name :: String.t()
  @type args :: PactValuesList.t()
  @type validation :: {:ok, any()} | {:error, atom()}
  @type t :: %__MODULE__{name: name(), args: args()}

  defstruct [:name, :args]

  @impl true
  def new(args) do
    name = Keyword.get(args, :name)
    args = Keyword.get(args, :args)

    with {:ok, name} <- validate_name(name),
         {:ok, args} <- validate_args(args) do
      %__MODULE__{name: name, args: args}
    end
  end

  @spec validate_name(name :: name()) :: validation()
  def validate_name(name) when is_binary(name), do: {:ok, name}
  def validate_name(_name), do: {:error, [:name, :invalid]}

  @spec validate_args(args :: list()) :: validation()
  def validate_args(args) when is_list(args) do
    with %PactValuesList{} = args <- PactValuesList.new(args) do
      {:ok, args}
    end
  end

  def validate_args(_args), do: {:error, [:args, :invalid]}
end
