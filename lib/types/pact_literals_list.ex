defmodule Kadena.Types.PactLiteralsList do
  @moduledoc """
  `PactLiteralsList` struct definition.
  """
  alias Kadena.Types.PactLiteral

  @behaviour Kadena.Types.Spec

  @type literals :: list(PactLiteral.t())

  @type t :: %__MODULE__{list: literals()}

  defstruct list: []

  @impl true
  def new(literals), do: build_list(%__MODULE__{}, literals)

  @spec build_list(list :: t(), literals :: literals()) :: t()
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [%PactLiteral{} = literal | rest]),
    do: build_list(%__MODULE__{list: [literal | list]}, rest)

  defp build_list(_list, _literals), do: {:error, :invalid_literal}
end
