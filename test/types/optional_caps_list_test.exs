defmodule Kadena.Types.OptionalCapsListTest do
  @moduledoc """
  `OptionalCapsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Cap, OptionalCapsList, PactValue}

  describe "new/1" do
    test "with a valid list" do
      cap1 = Cap.new(%{name: "gas", args: [PactValue.new("COIN.gas"), PactValue.new(0.02)]})

      cap2 =
        Cap.new(%{
          name: "transfer",
          args: [
            PactValue.new("COIN.transfer"),
            PactValue.new("key_1"),
            PactValue.new(50),
            PactValue.new("key_2")
          ]
        })

      clist = [cap1, cap2]
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
