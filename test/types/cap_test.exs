defmodule Kadena.Types.CapTest do
  @moduledoc """
  `Cap` struct definition tests.
  """

  alias Kadena.Types.{Cap, PactValue, PactValuesList}

  use ExUnit.Case

  describe "new/1" do
    test "with valid arguments" do
      decimal = Decimal.new("0.01")

      %Cap{
        name: "gas",
        args: %PactValuesList{
          pact_values: [%PactValue{literal: "COIN.gas"}, %PactValue{literal: ^decimal}]
        }
      } = Cap.new(name: "gas", args: ["COIN.gas", 1.0e-2])
    end

    test "with valid pact value list" do
      pact_value_list = PactValuesList.new(["COIN.gas", 1.0e-2])
      %Cap{name: "gas", args: ^pact_value_list} = Cap.new(name: "gas", args: pact_value_list)
    end

    test "with an empty list values" do
      %Kadena.Types.Cap{args: %Kadena.Types.PactValuesList{pact_values: []}, name: "gas"} =
        Cap.new(name: "gas", args: [])
    end

    test "with an invalid nil options list" do
      {:error, [args: :invalid]} = Cap.new(nil)
    end

    test "with an invalid nil args" do
      {:error, [args: :invalid]} = Cap.new(name: "gas", args: nil)
    end

    test "with an invalid nil name" do
      {:error, [name: :invalid]} = Cap.new(name: nil, args: ["COIN.gas", 20])
    end

    test "with an invalid name" do
      {:error, [name: :invalid]} = Cap.new(name: 123, args: ["COIN.gas", 20])
    end

    test "with an invalid values" do
      {:error, [args: :invalid]} = Cap.new(name: "gas", args: [true, :atom, nil, "COIN.gas"])
    end
  end
end
