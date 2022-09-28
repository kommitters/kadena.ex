defmodule Kadena.Types.CapsListTest do
  @moduledoc """
  `CapsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Cap, CapsList, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      decimal = Decimal.new("0.02")

      %CapsList{
        caps: [
          %Cap{
            name: "gas",
            args: %PactValuesList{
              pact_values: [
                %PactValue{literal: "COIN.gas"},
                %PactValue{literal: ^decimal}
              ]
            }
          },
          %Cap{
            name: "transfer",
            args: %PactValuesList{
              pact_values: [
                %PactValue{literal: "COIN.transfer"},
                %PactValue{literal: "key_1"},
                %PactValue{literal: 50},
                %PactValue{literal: "key_2"}
              ]
            }
          }
        ]
      } =
        CapsList.new([
          [name: "gas", args: ["COIN.gas", 0.02]],
          [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
        ])
    end

    test "with an empty list value" do
      %CapsList{caps: []} = CapsList.new([])
    end

    test "with a nil value" do
      {:error, [caps: :not_a_caps_list]} = CapsList.new(nil)
    end

    test "with an atom value" do
      {:error, [caps: :not_a_caps_list]} = CapsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [caps: :invalid]} = CapsList.new([nil])
    end

    test "when the list has invalid values" do
      {:error, [caps: :invalid]} =
        CapsList.new([
          [name: "gas", args: ["COIN.gas", 0.02]],
          :atom,
          [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
        ])
    end
  end
end
