defmodule Kadena.Chainweb.NetworkTest do
  use ExUnit.Case

  alias Kadena.Chainweb.Network

  @test_network_url "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/{chain_id}/pact/api/v1"
  @public_network_url "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/{chain_id}/pact/api/v1"

  test "base_url/0" do
    @test_network_url = Network.base_url()
  end

  test "current/0" do
    :test = Network.current()
  end

  describe "config/0" do
    setup do
      on_exit(fn -> Application.put_env(:kadena, :network, :test) end)
      Application.put_env(:kadena, :network, :public)
    end

    test "base_url/0" do
      @public_network_url = Network.base_url()
    end

    test "current/0" do
      :public = Network.current()
    end
  end
end
