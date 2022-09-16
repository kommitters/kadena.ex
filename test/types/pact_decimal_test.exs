defmodule Kadena.Types.PactDecimalTest do
  @moduledoc """
  `PactDecimal` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactDecimal

  describe "new/1" do
    test "With valid value" do
      %PactDecimal{value: decimal, raw_value: "4.3333333"} = PactDecimal.new("4.3333333")
      assert Decimal.equal?(decimal, Decimal.new("4.3333333"))
    end

    test "With nil value" do
      {:error, :invalid_decimal} = PactDecimal.new(nil)
    end

    test "With atom value" do
      {:error, :invalid_decimal} = PactDecimal.new(:atom)
    end

    test "With list of nil" do
      {:error, :invalid_decimal} = PactDecimal.new([nil])
    end

    test "With one list item with valid value" do
      {:error, :invalid_decimal} = PactDecimal.new(["2.333", nil, true])
    end

    test "With each list item with invalid value" do
      {:error, :invalid_decimal} = PactDecimal.new([:atom, nil, true])
    end

    test "With empty list value" do
      {:error, :invalid_decimal} = PactDecimal.new([])
    end
  end
end
