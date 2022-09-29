defmodule Kadena.Types.NetworkIDTest do
  @moduledoc """
  `NetworkID` struct definition tests.
  """

  alias Kadena.Types.NetworkID

  use ExUnit.Case

  describe "new/1" do
    test "with a valid mainnet value" do
      %NetworkID{id: "Mainnet01"} = NetworkID.new(:mainnet01)
    end

    test "with a valid testnet value" do
      %NetworkID{id: "Testnet04"} = NetworkID.new(:testnet04)
    end

    test "with a valid development value" do
      %NetworkID{id: "Development"} = NetworkID.new(:development)
    end

    test "with a nil value" do
      %NetworkID{id: nil} = NetworkID.new(nil)
    end

    test "with an invalid atom" do
      {:error, [id: :invalid]} = NetworkID.new(:atom)
    end

    test "with an invalid string" do
      {:error, [id: :invalid]} = NetworkID.new("mainnet01")
    end
  end
end
