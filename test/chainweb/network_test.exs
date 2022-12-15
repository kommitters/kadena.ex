defmodule Kadena.Chainweb.NetworkTest do
  use ExUnit.Case

  alias Kadena.Chainweb.{Network, Request}

  test "base_url/1 with_nil_network_id" do
    nil = Network.base_url(%Request{api_type: :pact, network_id: nil, chain_id: 0})
  end

  test "base_url/1 pact_with_nil_chain_id" do
    nil = Network.base_url(%Request{api_type: :pact, network_id: :testnet04, chain_id: nil})
  end

  test "base_url/1 with_invalid_api_type" do
    assert_raise FunctionClauseError, fn ->
      Network.base_url(%Request{api_type: :invalid, network_id: :testnet04, chain_id: 0})
    end
  end

  test "base_url/1 pact_testnet04_chain0" do
    "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/pact/api/v1" =
      Network.base_url(%Request{api_type: :pact, network_id: :testnet04, chain_id: 0})
  end

  test "base_url/1 pact_mainnet01_chain0" do
    "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1" =
      Network.base_url(%Request{api_type: :pact, network_id: :mainnet01, chain_id: 0})
  end

  test "base_url/1 p2p_testnet04" do
    "https://api.testnet.chainweb.com/chainweb/0.0/testnet04" =
      Network.base_url(%Request{api_type: :p2p, network_id: :testnet04})
  end

  test "base_url/1 p2p_mainnet01" do
    "https://api.chainweb.com/chainweb/0.0/mainnet01" =
      Network.base_url(%Request{api_type: :p2p, network_id: :mainnet01})
  end

  test "base_url/1 p2p_testnet04_chain0" do
    "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0" =
      Network.base_url(%Request{api_type: :p2p, network_id: :testnet04, chain_id: 0})
  end

  test "base_url/1 p2p_mainnet01_chain0" do
    "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0" =
      Network.base_url(%Request{api_type: :p2p, network_id: :mainnet01, chain_id: 0})
  end
end
