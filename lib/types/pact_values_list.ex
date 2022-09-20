defmodule Kadena.Types.PactValuesList do
  @moduledoc """
  `PactValuesList` struct definition.
  """
  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type values :: list(PactValue.t())

  @type t :: %__MODULE__{list: values()}

  defstruct list: []

  @impl true
  def new(values), do: build_list(%__MODULE__{}, values)

  @spec build_list(list :: t(), values :: values()) :: t()
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [%PactValue{} = value | rest]),
    do: build_list(%__MODULE__{list: [value | list]}, rest)

  defp build_list(_list, _values), do: {:error, :invalid_value}
end
