defmodule Kadena.Types.PactValuesList do
  @moduledoc """
  `PactValuesList` struct definition.
  """
  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type literal :: String.t() | number() | boolean()
  @type literals :: list(literal())
  @type error_list :: Keyword.t()
  @type pact_values :: list(PactValue.t())

  @type t :: %__MODULE__{pact_values: pact_values()}

  defstruct pact_values: []

  @impl true
  def new(literals), do: build_list(%__MODULE__{}, literals)

  @spec build_list(struct :: t(), literals :: literals()) :: t() | {:error, error_list()}
  defp build_list(struct, []), do: struct

  defp build_list(%__MODULE__{pact_values: list}, [value | rest]) do
    case PactValue.new(value) do
      %PactValue{} = pact_value ->
        build_list(%__MODULE__{pact_values: list ++ [pact_value]}, rest)

      {:error, _reason} ->
        {:error, [pact_values: :invalid]}
    end
  end

  defp build_list(_struct, _literals), do: {:error, [pact_values: :not_a_literals_list]}
end
