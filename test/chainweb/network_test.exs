defmodule Kadena.Chainweb.NetworkTest do
  @moduledoc """
  `Util.Network` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Util.Network

  setup do
    %{
      headers: [{"Content-Type", "application/json"}],
      testnet: "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/pact/api/v1",
      public: "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1",
      public_2: "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/2/pact/api/v1"
    }
  end

  describe "base_url/2" do
    test "with empty args", %{testnet: testnet} do
      ^testnet = Network.base_url()
    end

    test "with valid network arg", %{public: public} do
      ^public = Network.base_url(:public)
    end

    test "with valid chain_id arg", %{public_2: public_2} do
      ^public_2 = Network.base_url(:public, "2")
    end
  end

  describe "base_headers/0" do
    test "with empty args", %{headers: headers} do
      ^headers = Network.base_headers()
    end
  end
end
