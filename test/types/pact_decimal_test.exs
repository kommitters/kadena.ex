defmodule Kadena.Types.PactDecimalTest do
  @moduledoc """
  `PactDecimal` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactDecimal

  describe "new/1" do
    test "with a valid value" do
      decimal = Decimal.new("9007199254740992.553")

      %PactDecimal{value: "9007199254740992.553", raw_value: ^decimal} =
        PactDecimal.new("9007199254740992.553")
    end

    test "with valid out of range" do
      {:error, [value: :not_in_range]} = PactDecimal.new("4.3333333")
    end

    test "with an invalid integer value" do
      {:error, [value: :invalid]} = PactDecimal.new(9_007_199_254_740_992)
    end

    test "with an invalid value" do
      {:error, [value: :invalid]} = PactDecimal.new(4.3333333)
    end

    test "with a nil value" do
      {:error, [value: :invalid]} = PactDecimal.new(nil)
    end

    test "with an atom value" do
      {:error, [value: :invalid]} = PactDecimal.new(:atom)
    end

    test "with an empty list" do
      {:error, [value: :invalid]} = PactDecimal.new([])
    end
  end
end
