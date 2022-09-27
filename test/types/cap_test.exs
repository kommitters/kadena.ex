defmodule Kadena.Types.CapTest do
  @moduledoc """
  `Cap` struct definition tests.
  """

  alias Kadena.Types.{Cap, PactValue, PactValuesList}

  use ExUnit.Case

  describe "new/1" do
    test "with valid arguments" do
      %Cap{
        name: "gas",
        args: %PactValuesList{list: [%PactValue{value: 0.01}, %PactValue{value: "COIN.gas"}]}
      } = Cap.new(name: "has", args: ["COIN.gas", 1.0e-2])
    end

    test "with an invalid name" do
      {:error, [:name, :invalid]} = Cap.new(name: 123, args: ["COIN.gas", 20])
    end

    test "with an invalid values" do
      {:error, [:name, :invalid]} = Cap.new(name: 123, args: [true, :atom, nil, "COIN.gas"])
    end

    test "with an empty list values" do
      {:error, [:name, :invalid]} = Cap.new(name: 123, args: [])
    end
  end
end
