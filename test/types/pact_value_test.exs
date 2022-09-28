defmodule Kadena.Types.PactValueTest do
  @moduledoc """
  `PactValue` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactDecimal, PactInt, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid string" do
      %PactValue{literal: "string"} = PactValue.new("string")
    end

    test "with a valid PactInt" do
      %PactValue{literal: %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992}} =
        PactValue.new(9_007_199_254_740_992)
    end

    test "with a valid PactDecimal" do
      decimal = Decimal.new("9007199254740992.553")

      %PactValue{literal: %PactDecimal{value: "9007199254740992.553", raw_value: ^decimal}} =
        PactValue.new("9007199254740992.553")
    end

    test "with a valid boolean" do
      %PactValue{literal: true} = PactValue.new(true)
    end

    test "with a valid PactLiteralList" do
      decimal = Decimal.new("0.01")

      %PactValue{
        literal: %PactValuesList{
          pact_values: [%PactValue{literal: "COIN.gas"}, %PactValue{literal: ^decimal}]
        }
      } = PactValue.new(["COIN.gas", 1.0e-2])
    end

    test "with a valid list of pact values" do
      pact_value_list = PactValuesList.new(["COIN.gas", 1.0e-2])
      %PactValue{literal: ^pact_value_list} = PactValue.new(pact_value_list)
    end

    test "with empty list value" do
      %PactValue{literal: %PactValuesList{pact_values: []}} = PactValue.new([])
    end

    test "with an invalid list" do
      {:error, [literal: :invalid]} = PactValue.new(["string", :atom, true])
    end

    test "with a nil value" do
      {:error, [literal: :invalid]} = PactValue.new(nil)
    end

    test "with an atom value" do
      {:error, [literal: :invalid]} = PactValue.new(:atom)
    end

    test "with a list of nil" do
      {:error, [literal: :invalid]} = PactValue.new([nil])
    end
  end
end
