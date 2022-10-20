defmodule Kadena.Pact.Number.Spec do
  @moduledoc """
  Specification for `Pact.Number` contracts.
  """
  alias Kadena.Types.{PactDecimal, PactInt}

  @type str :: String.t()
  @type pact_integer :: PactInt.t()
  @type pact_decimal :: PactDecimal.t()

  @callback to_pact_integer(str()) :: {:ok, pact_integer()}
  @callback to_pact_decimal(str()) :: {:ok, pact_decimal()}
  @callback to_stringified(str()) :: {:ok, str()}
end
