defmodule Kadena.Types.OptionalCapsListTest do
  @moduledoc """
  `OptionalCapsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{CapsList, OptionalCapsList}

  describe "new/1" do
    test "with a valid list" do
      clist =
        CapsList.new([
          [name: "gas", args: ["COIN.gas", 0.02]],
          [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
        ])

      %OptionalCapsList{clist: ^clist} = OptionalCapsList.new(clist)
    end

    test "without setting the args" do
      %OptionalCapsList{clist: nil} = OptionalCapsList.new()
    end

    test "with a nil value" do
      %OptionalCapsList{clist: nil} = OptionalCapsList.new(nil)
    end

    test "with an empty list value" do
      {:error, [clist: :invalid]} = OptionalCapsList.new([])
    end

    test "with an atom value" do
      {:error, [clist: :invalid]} = OptionalCapsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [clist: :invalid]} = OptionalCapsList.new([nil])
    end
  end
end
