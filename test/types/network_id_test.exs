defmodule Kadena.Types.NetworkIdTest do
  @moduledoc """
  `NetworkId` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.NetworkId

  describe "new/1" do
    test "with a valid mainnet value" do
      %NetworkId{id: :mainnet01} = NetworkId.new(:mainnet01)
    end

    test "with a valid testnet value" do
      %NetworkId{id: :testnet04} = NetworkId.new(:testnet04)
    end

    test "with a valid development value" do
      %NetworkId{id: :development} = NetworkId.new(:development)
    end

    test "with a nil value" do
      %NetworkId{id: nil} = NetworkId.new(nil)
    end

    test "with an invalid atom" do
      {:error, :invalid_network_id} = NetworkId.new(:atom)
    end

    test "with an invalid string" do
      {:error, :invalid_network_id} = NetworkId.new("mainnet01")
    end
  end
end
