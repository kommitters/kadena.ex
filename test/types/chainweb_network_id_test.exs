defmodule Kadena.Types.ChainwebNetworkIDTest do
  @moduledoc """
  `ChainwebNetworkID` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.ChainwebNetworkID

  describe "new/1" do
    test "with a valid mainnet value" do
      %ChainwebNetworkID{id: :mainnet01} = ChainwebNetworkID.new(:mainnet01)
    end

    test "with a valid testnet value" do
      %ChainwebNetworkID{id: :testnet04} = ChainwebNetworkID.new(:testnet04)
    end

    test "with a valid development value" do
      %ChainwebNetworkID{id: :development} = ChainwebNetworkID.new(:development)
    end

    test "with a nil value" do
      %ChainwebNetworkID{id: nil} = ChainwebNetworkID.new(nil)
    end

    test "with an invalid atom" do
      {:error, [id: :invalid]} = ChainwebNetworkID.new(:atom)
    end

    test "with an invalid string" do
      {:error, [id: :invalid]} = ChainwebNetworkID.new("mainnet01")
    end
  end
end
