defmodule Kadena.Types.PactIntTest do
  @moduledoc """
  `PactInt` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactInt

  describe "new/1" do
    test "with a valid integer value" do
      %PactInt{value: "9007199254740992", raw_value: 9_007_199_254_740_992} =
        PactInt.new(9_007_199_254_740_992)
    end

    test "with an invalid integer value" do
      {:error, [value: :not_in_range]} = PactInt.new(500)
    end

    test "with an invalid decimal value" do
      {:error, [value: :invalid]} = PactInt.new(9_007_199_254_740_992.553)
    end

    test "with a nil value" do
      {:error, [value: :invalid]} = PactInt.new(nil)
    end

    test "with an atom value" do
      {:error, [value: :invalid]} = PactInt.new(:atom)
    end

    test "with an empty list" do
      {:error, [value: :invalid]} = PactInt.new([])
    end
  end
end
