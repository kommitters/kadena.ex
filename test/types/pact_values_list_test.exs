defmodule Kadena.Types.PactValuesListTest do
  @moduledoc """
  `PactValuesList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      %PactValuesList{
        list: [%PactValue{value: 20}, %PactValue{value: "COIN.transfer"}]
      } = PactValuesList.new(["COIN.transfer", 20])
    end

    test "with an empty list value" do
      %PactValuesList{list: []} = PactValuesList.new([])
    end

    test "with a nil value" do
      {:error, [list: :invalid_type]} = PactValuesList.new(nil)
    end

    test "with an atom value" do
      {:error, [list: :invalid_type]} = PactValuesList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [value: :invalid_type]} = PactValuesList.new([nil])
    end

    test "when the list has invalid values" do
      {:error, [value: :invalid_type]} = PactValuesList.new(["string", 20, :atom, true])
    end
  end
end
