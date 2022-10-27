defmodule Kadena.PactTest do
  @moduledoc """
  Kadena.Pact  tests.
  """

  use ExUnit.Case

  alias Kadena.Pact
  alias Kadena.Types.{PactDecimal, PactInt}

  describe "create_exp/1" do
    test "with valid args" do
      {:ok, "(* 5 5)"} = Pact.create_exp(["*", 5, 5])
    end

    test "with an invalid no list args" do
      {:error, [args: :not_a_list]} = Pact.create_exp("")
    end
  end

  describe "to_pact_integer/1" do
    test "with a valid integer" do
      {:ok, %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992}} =
        Pact.to_pact_integer("9007199254740992")
    end

    test "with a valid decimal" do
      {:ok, %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992}} =
        Pact.to_pact_integer("9007199254740992.56")
    end
  end

  describe "to_pact_decimal/1" do
    test "with a valid decimal" do
      decimal = Decimal.new("9007199254740992.56")

      {:ok, %PactDecimal{value: "9007199254740992.56", raw_value: ^decimal}} =
        Pact.to_pact_decimal("9007199254740992.56")
    end

    test "with an invalid decimal" do
      {:error, [value: :invalid]} = Pact.to_pact_decimal(9_007_199_254_740_992.56)
    end
  end

  describe "to_json_string/1" do
    test "with a valid stringified integer" do
      {:ok, "\"233\""} = Pact.to_json_string("233")
    end

    test "with a valid stringified decimal" do
      {:ok, "\"233.56\""} = Pact.to_json_string("233.56")
    end

    test "with a valid integer" do
      {:ok, "\"233\""} = Pact.to_json_string(233)
    end

    test "with a valid decimal" do
      {:ok, "\"233.56\""} = Pact.to_json_string(233.56)
    end

    test "with a valid PactInt" do
      {:ok, "\"9007199254740992\""} =
        9_007_199_254_740_992 |> PactInt.new() |> Pact.to_json_string()
    end

    test "with a valid PactDecimal" do
      {:ok, "\"9007199254740992.56\""} =
        "9007199254740992.56" |> PactDecimal.new() |> Pact.to_json_string()
    end

    test "with an invalid value" do
      {:error, [value: :invalid]} = Pact.to_json_string(:invalid_value)
    end
  end
end
