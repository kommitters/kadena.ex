defmodule Kadena.Pact.Number do
  @moduledoc """
  Implementation for `Pact.Number`.
  """
  alias Kadena.Types.{PactDecimal, PactInt}

  def to_pact_integer(number) do
    with {number, _rest} <- Integer.parse(number),
         %PactInt{} = pact_int <- PactInt.new(number) do
      {:ok, pact_int}
    end
  end

  def to_pact_decimal(decimal) do
    case PactDecimal.new(decimal) do
      %PactDecimal{} = pact_decimal -> {:ok, pact_decimal}
      error -> error
    end
  end

  def to_stringified(number) when is_binary(number), do: Jason.encode(number)

  def to_stringified(%PactInt{value: number}), do: Jason.encode(number)
  def to_stringified(%PactDecimal{value: number}), do: Jason.encode(number)
  def to_stringified(_number), do: {:error, [number: :invalid]}
end
