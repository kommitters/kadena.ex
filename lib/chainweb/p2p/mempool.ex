defmodule Kadena.Chainweb.P2P.Mempool do
  @moduledoc """
  Mempool endpoints implementation for P2P API.
  """

  alias Kadena.Chainweb.P2P.MempoolResponse
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type network_id :: :mainnet01 | :testnet04
  @type location :: String.t()
  @type response :: {:ok, MempoolResponse.t()} | error()

  @endpoint "mempool"

  @spec retrieve_pending_txs(network_opts :: network_opts()) :: response()
  def retrieve_pending_txs(network_opts \\ []) do
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])
    location = Keyword.get(network_opts, :location, set_default_location(network_id))

    :post
    |> Request.new(p2p: [endpoint: @endpoint, path: "getPending"])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_query(query_params)
    |> Request.set_chain_id(chain_id)
    |> Request.perform()
    |> Request.results(as: MempoolResponse)
  end

  @spec set_default_location(network_id :: network_id()) :: location()
  defp set_default_location(:testnet04), do: "us1"
  defp set_default_location(:mainnet01), do: "us-e1"
end
