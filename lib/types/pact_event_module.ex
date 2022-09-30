defmodule Kadena.Types.PactEventModule do
  @moduledoc """
  `PactEventModule` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type name :: String.t()
  @type name_space :: String.t() | nil
  @type value :: name() | name_space()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{name: name(), name_space: name_space()}

  defstruct [:name, :name_space]

  @impl true
  def new(args) do
    name = Keyword.get(args, :name)
    name_space = Keyword.get(args, :name_space)

    with {:ok, name} <- validate_string(:name, name),
         {:ok, name_space} <- validate_string(:name_space, name_space) do
      %__MODULE__{name: name, name_space: name_space}
    end
  end

  @spec validate_string(field :: atom(), value :: value()) :: validation()
  defp validate_string(_field, value) when is_binary(value), do: {:ok, value}
  defp validate_string(:name_space, nil), do: {:ok, nil}
  defp validate_string(field, _value), do: {:error, [{field, :invalid}]}
end
