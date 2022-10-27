defmodule Kadena.Chainweb.Util.Network do
  @moduledoc """
  Utility that handles Kadena's network configuration.
  """

  @type chain_id :: String.t()
  @type network :: :public | :test
  @type url :: String.t()
  @type header :: String.t()
  @type value :: String.t()
  @type headers :: list({header(), value()})

  @base_urls [
    test: "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/{chain_id}/pact/api/v1",
    public: "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/{chain_id}/pact/api/v1"
  ]

  @spec base_url(network :: network(), chain_id :: chain_id()) :: url()
  def base_url(network \\ :test, chain_id \\ "0"), do: replace_chain_id(network, chain_id)

  @spec base_headers() :: headers()
  def base_headers(), do: [{"Content-Type", "application/json"}]

  @spec replace_chain_id(network :: network(), chain_id :: chain_id()) :: url()
  def replace_chain_id(network, chain_id),
    do: @base_urls[network] |> String.replace("{chain_id}", chain_id)
end
