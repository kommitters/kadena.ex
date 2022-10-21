defmodule Kadena.Pact.Number do
  @moduledoc """
  Implementation for `Pact.Number` functions.
  """
  alias Kadena.Types.{PactDecimal, PactInt}

  @type str :: String.t()
  @type pact_decimal :: PactDecimal.t()
  @type pact_int :: PactInt.t()
  @type pact_number :: pact_decimal() | pact_int()
  @type value :: str() | pact_number()
  @type error :: {:error, Keyword.t()}
  @type valid_pact_number :: {:ok, pact_number()}
  @type valid_json_str :: {:ok, str()}

  @spec to_pact_integer(str :: str()) :: valid_pact_number() | error()
  def to_pact_integer(str) do
    with {number, _rest} <- Integer.parse(str),
         %PactInt{} = pact_int <- PactInt.new(number) do
      {:ok, pact_int}
    end
  end

  @spec to_pact_decimal(str :: str()) :: valid_pact_number() | error()
  def to_pact_decimal(str) do
    case PactDecimal.new(str) do
      %PactDecimal{} = pact_decimal -> {:ok, pact_decimal}
      error -> error
    end
  end

  @spec to_json_string(value()) :: valid_json_str() | error()
  def to_json_string(str) when is_binary(str), do: Jason.encode(str)
  def to_json_string(number) when is_number(number), do: number |> to_string() |> Jason.encode()
  def to_json_string(%PactInt{value: str}), do: Jason.encode(str)
  def to_json_string(%PactDecimal{value: str}), do: Jason.encode(str)
  def to_json_string(_value), do: {:error, [value: :invalid]}
end
