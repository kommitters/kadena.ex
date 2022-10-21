defmodule Kadena.Pact.Number do
  @moduledoc """
  Implementation for `Pact.Number` functions.
  """
  alias Kadena.Types.{PactDecimal, PactInt}

  @type str :: String.t()
  @type pact_decimal :: PactDecimal.t()
  @type pact_int :: PactInt.t()
  @type value :: str() | pact_decimal() | pact_int()
  @type response :: {:ok, value()} | {:error, Keyword.t()}

  @spec to_pact_integer(number :: str()) :: response()
  def to_pact_integer(number) do
    with {number, _rest} <- Integer.parse(number),
         %PactInt{} = pact_int <- PactInt.new(number) do
      {:ok, pact_int}
    end
  end

  @spec to_pact_decimal(decimal :: str()) :: response()
  def to_pact_decimal(decimal) do
    case PactDecimal.new(decimal) do
      %PactDecimal{} = pact_decimal -> {:ok, pact_decimal}
      error -> error
    end
  end

  @spec to_stringified(number :: value()) :: response()
  def to_stringified(number) when is_binary(number), do: Jason.encode(number)

  def to_stringified(%PactInt{value: number}), do: Jason.encode(number)
  def to_stringified(%PactDecimal{value: number}), do: Jason.encode(number)
  def to_stringified(_number), do: {:error, [number: :invalid]}
end
