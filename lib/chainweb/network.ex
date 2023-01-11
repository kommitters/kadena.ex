defmodule Kadena.Chainweb.Network do
  @moduledoc """
  Utility that handles Chainweb network URL resolution.
  """

  alias Kadena.Chainweb.Request

  @type request :: Request.t()

  @base_urls [
    testnet04: "https://api.testnet.chainweb.com/chainweb/0.0/testnet04",
    mainnet01: "https://api.chainweb.com/chainweb/0.0/mainnet01"
  ]

  @spec base_url(request :: request()) :: String.t() | nil
  def base_url(%Request{network_id: nil}), do: nil
  def base_url(%Request{api_type: :pact, chain_id: nil}), do: nil

  def base_url(%Request{
        api_type: :pact,
        endpoint: "spv",
        network_id: network_id,
        chain_id: chain_id
      }),
      do: "#{@base_urls[network_id]}/chain/#{chain_id}/pact"

  def base_url(%Request{api_type: :pact, network_id: network_id, chain_id: chain_id}),
    do: "#{@base_urls[network_id]}/chain/#{chain_id}/pact/api/v1"

  def base_url(%Request{api_type: :p2p, network_id: network_id, chain_id: nil, location: nil}),
    do: @base_urls[network_id]

  def base_url(%Request{api_type: :p2p, network_id: network_id, chain_id: nil, location: location}),
      do: String.replace(@base_urls[network_id], "api", location)

  def base_url(%Request{
        api_type: :p2p,
        network_id: network_id,
        chain_id: chain_id,
        location: nil
      }),
      do: "#{@base_urls[network_id]}/chain/#{chain_id}"

  def base_url(%Request{
        api_type: :p2p,
        network_id: network_id,
        chain_id: chain_id,
        location: location
      }),
      do: String.replace(@base_urls[network_id], "api", location) <> "/chain/#{chain_id}"
end
