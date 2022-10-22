defmodule Kadena.Chainweb.Network do
  @moduledoc """
  Utility that handles Kadena's network configuration.
  """

  @base_urls [
    test: "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/{chain_id}/pact/api/v1",
    public: "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/{chain_id}/pact/api/v1"
  ]

  @spec base_url() :: String.t()
  def base_url do
    default = @base_urls[:test]
    Keyword.get(@base_urls, current(), default)
  end

  @spec current() :: atom()
  def current, do: Application.get_env(:kadena, :network, :test)
end
