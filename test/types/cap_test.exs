defmodule Kadena.Types.CapTest do
  @moduledoc """
  `Cap` struct definition tests.
  """

  alias Kadena.Types.{Cap, PactValue}

  use ExUnit.Case

  describe "new/1" do
    test "with valid Keyword arguments" do
      decimal = Decimal.new("0.01")

      %Cap{
        name: "gas",
        args: [%PactValue{literal: "COIN.gas"}, %PactValue{literal: ^decimal}]
      } = Cap.new(name: "gas", args: [PactValue.new("COIN.gas"), PactValue.new(1.0e-2)])
    end

    test "with valid map arguments" do
      decimal = Decimal.new("0.01")

      %Cap{
        name: "gas",
        args: [%PactValue{literal: "COIN.gas"}, %PactValue{literal: ^decimal}]
      } = Cap.new(%{name: "gas", args: [PactValue.new("COIN.gas"), PactValue.new(1.0e-2)]})
    end

    test "with valid pact value list" do
      pact_value_list = [PactValue.new("COIN.gas"), PactValue.new(1.0e-2)]
      %Cap{name: "gas", args: ^pact_value_list} = Cap.new(name: "gas", args: pact_value_list)
    end

    test "with an empty list values" do
      %Kadena.Types.Cap{args: [], name: "gas"} = Cap.new(name: "gas", args: [])
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
