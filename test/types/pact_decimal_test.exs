defmodule Kadena.Types.PactDecimalTest do
  @moduledoc """
  `PactDecimal` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactDecimal

  describe "new/1" do
    test "with a valid value" do
      expected_value = Decimal.new("4.3333333")
      %PactDecimal{value: ^expected_value, raw_value: "4.3333333"} = PactDecimal.new("4.3333333")
    end

    test "with a nil value" do
      {:error, :invalid_decimal} = PactDecimal.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_decimal} = PactDecimal.new(:atom)
    end

    test "with an empty list" do
      {:error, :invalid_decimal} = PactDecimal.new([])
    end
  end
end
