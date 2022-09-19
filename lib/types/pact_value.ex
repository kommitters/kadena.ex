defmodule Kadena.Types.PactValue do
  @moduledoc """
  `PactValue` structure definition.
  """
  alias Kadena.Types.{PactLiteral, PactLiteralsList}

  @behaviour Kadena.Types.Spec

  @type pact_value :: PactLiteral.t() | PactLiteralsList.t()

  @type t :: %__MODULE__{value: pact_value()}

  defstruct [:value]

  @impl true
  def new(%PactLiteral{} = literal), do: %__MODULE__{value: literal}
  def new(%PactLiteralsList{} = literal_list), do: %__MODULE__{value: literal_list}
  def new(_value), do: {:error, :invalid_value}
end
