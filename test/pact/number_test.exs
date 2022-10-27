defmodule Kadena.Pact.NumberTest do
  @moduledoc """
  `Pact.Number` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.Number
  alias Kadena.Types.{PactDecimal, PactInt}

  describe "to_pact_integer/1" do
    test "with a valid integer" do
      {:ok, %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992}} =
        Number.to_pact_integer("9007199254740992")
    end

    test "with a invalid value" do
      {:error, [value: :not_an_integer]} = Number.to_pact_integer("No_Parse_String")
    end

    test "with a valid decimal" do
      {:ok, %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992}} =
        Number.to_pact_integer("9007199254740992.56")
    end
  end

  describe "to_pact_decimal/1" do
    test "with a valid decimal" do
      decimal = Decimal.new("9007199254740992.56")

      {:ok, %PactDecimal{value: "9007199254740992.56", raw_value: ^decimal}} =
        Number.to_pact_decimal("9007199254740992.56")
    end

    test "with an invalid decimal" do
      {:error, [value: :invalid]} = Number.to_pact_decimal(9_007_199_254_740_992.56)
    end
  end

  describe "to_json_string/1" do
    test "with a valid stringified integer" do
      {:ok, "\"233\""} = Number.to_json_string("233")
    end

    test "with a valid stringified decimal" do
      {:ok, "\"233.56\""} = Number.to_json_string("233.56")
    end

    test "with a valid integer" do
      {:ok, "\"233\""} = Number.to_json_string(233)
    end

    test "with a valid decimal" do
      {:ok, "\"233.56\""} = Number.to_json_string(233.56)
    end

    test "with a valid PactInt" do
      {:ok, "\"9007199254740992\""} =
        9_007_199_254_740_992 |> PactInt.new() |> Number.to_json_string()
    end

    test "with a valid PactDecimal" do
      {:ok, "\"9007199254740992.56\""} =
        "9007199254740992.56" |> PactDecimal.new() |> Number.to_json_string()
    end

    test "with an invalid value" do
      {:error, [value: :invalid]} = Number.to_json_string(:invalid_value)
    end
  end
end
