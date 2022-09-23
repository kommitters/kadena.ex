defmodule Kadena.Types.PactValueTest do
  @moduledoc """
  `PactValue` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactDecimal, PactInt, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid string" do
      %PactValue{value: "string"} = PactValue.new("string")
    end

    test "with a valid PactInt" do
      %PactValue{value: %PactInt{value: 9_007_199_254_740_992, raw_value: "9007199254740992"}} =
        PactValue.new(9_007_199_254_740_992)
    end

    test "with a valid PactDecimal" do
      %PactValue{value: %PactDecimal{raw_value: "9.007199254740992e15"}} =
        PactValue.new(9_007_199_254_740_992.553)
    end

    test "with a valid boolean" do
      %PactValue{value: true} = PactValue.new(true)
    end

    test "with a valid PactLiteralList" do
      %PactValue{
        value: %PactValuesList{list: [%PactValue{value: 0.01}, %PactValue{value: "COIN.gas"}]}
      } = PactValue.new(["COIN.gas", 1.0e-2])
    end

    test "with an invalid list" do
      {:error, [value: :invalid_type]} = PactValue.new(["string", :atom, true])
    end

    test "with a nil value" do
      {:error, [value: :invalid_type]} = PactValue.new(nil)
    end

    test "with an atom value" do
      {:error, [value: :invalid_type]} = PactValue.new(:atom)
    end

    test "with a list of nil" do
      {:error, [value: :invalid_type]} = PactValue.new([nil])
    end

    test "with empty list value" do
      {:error, [value: :invalid_type]} = PactValue.new([])
    end
  end
end
