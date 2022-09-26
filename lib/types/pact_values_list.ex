defmodule Kadena.Types.PactValuesList do
  @moduledoc """
  `PactValuesList` struct definition.
  """
  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type literal :: String.t() | number() | boolean()
  @type values :: list(PactValue.t())

  @type t :: %__MODULE__{list: values()}

  defstruct list: []

  @impl true
  def new(values), do: build_list(%__MODULE__{}, values)

  @spec build_list(list :: t(), values :: list(literal())) :: t() | {:error, list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [value | rest]) do
    with %PactValue{} = pact_value <- PactValue.new(value) do
      build_list(%__MODULE__{list: [pact_value | list]}, rest)
    end
  end

  defp build_list(_list, _rest), do: {:error, [list: :invalid_type]}
end
