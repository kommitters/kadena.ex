defmodule Kadena.Types.Uint8Array do
  @moduledoc """
  `Uint8Array` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type values :: binary() | list(integer())
  @type t :: %__MODULE__{value: values}

  defstruct [:value]

  @impl true
  def new(buffer) when is_binary(buffer), do: %__MODULE__{value: :binary.bin_to_list(buffer)}
  def new(list) when is_list(list), do: check_list(%__MODULE__{value: list}, list)
  def new(_value), do: {:error, :invalid_uint8_array}

  @spec check_list(module_list :: t(), values :: list(integer())) :: t()
  defp check_list(module_list, []), do: module_list

  defp check_list(module_list, [value | rest]) when is_integer(value) and value >= 0,
    do: check_list(module_list, rest)

  defp check_list(_module_list, _values), do: {:error, :invalid_uint8_array}
end
