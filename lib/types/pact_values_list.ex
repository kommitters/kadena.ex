defmodule Kadena.Types.PactValuesList do
  @moduledoc """
  `PactValuesList` struct definition.
  """
  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type literal :: String.t() | number() | boolean()
  @type literals :: list(literal())
  @type error_list :: Keyword.t()
  @type pact_value :: PactValue.t()
  @type pact_values :: list(pact_value())

  @type t :: %__MODULE__{pact_values: pact_values(), json: json()}

  defstruct pact_values: [], json: ""

  @impl true
  def new([]), do: %__MODULE__{json: "[]"}
  def new(literals), do: build_list(%__MODULE__{json: "["}, literals)

  @spec build_list(struct :: t(), literals :: literals()) :: t() | {:error, error_list()}
  defp build_list(struct, []), do: struct

  defp build_list(%__MODULE__{pact_values: list} = module, [value | rest]) do
    case PactValue.new(value) do
      %PactValue{} = pact_value ->
        build_list(
          %__MODULE__{
            pact_values: list ++ [pact_value],
            json: concatenate_json(module, pact_value, rest)
          },
          rest
        )

      {:error, _reason} ->
        {:error, [pact_values: :invalid]}
    end
  end

  defp build_list(_struct, _literals), do: {:error, [pact_values: :not_a_literals_list]}

  @spec concatenate_json(module :: t(), pact_value :: pact_value(), rest :: list()) :: json()
  defp concatenate_json(%__MODULE__{json: json}, %PactValue{json: pact_value_json}, []),
    do: json <> pact_value_json <> "]"

  defp concatenate_json(%__MODULE__{json: json}, %PactValue{json: pact_value_json}, _rest),
    do: json <> pact_value_json <> ","
end
