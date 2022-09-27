defmodule Kadena.Types.CapsListTest do
  @moduledoc """
  `CapsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Cap, CapsList, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      %CapsList{
        list: [
          %Cap{
            name: "transfer",
            args: %PactValuesList{
              list: [
                %PactValue{value: "key_2"},
                %PactValue{value: 50},
                %PactValue{value: "key_1"},
                %PactValue{value: "COIN.transfer"}
              ]
            }
          },
          %Cap{}
        ]
      } =
        CapsList.new([
          [name: "gas", args: ["COIN.gas", 0.02]],
          [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
        ])
    end

    test "with an empty list value" do
      %CapsList{list: []} = CapsList.new([])
    end

    test "with a nil value" do
      {:error, [list: :invalid_cap]} = CapsList.new(nil)
    end

    test "with an atom value" do
      {:error, [list: :invalid_cap]} = CapsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [list: :invalid_cap]} = CapsList.new([nil])
    end

    test "when the list has invalid values" do
      {:error, [list: :invalid_cap]} =
        CapsList.new([
          [name: "gas", args: ["COIN.gas", 0.02]],
          :atom,
          [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
        ])
    end
  end
end
