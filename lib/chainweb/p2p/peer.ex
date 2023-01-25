defmodule Kadena.Chainweb.P2P.Peer do
  @moduledoc """
  Peer endpoints implementation for P2P API.
  """

  alias Kadena.Chainweb.P2P.{PeerPutResponse, PeerRequestBody, PeerResponse}
  alias Kadena.Chainweb.{Error, Peer, Request}

  @type json :: String.t()
  @type network_opts :: Keyword.t()
  @type network_id :: :testnet04 | :mainnet01
  @type error :: {:error, Error.t()}
  @type location :: String.t()
  @type peer :: Peer.t()
  @type peer_response :: PeerResponse.t() | PeerPutResponse.t()
  @type response :: {:ok, peer_response()} | error()

  @cut_endpoint "cut"
  @mempool_endpoint "mempool"
  @path "peer"

  @spec retrieve_cut_info(network_opts :: network_opts()) :: response()
  def retrieve_cut_info(network_opts \\ []) do
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    location = Keyword.get(network_opts, :location, set_default_location(network_id))
    query_params = Keyword.get(network_opts, :query_params, [])

    :get
    |> Request.new(p2p: [endpoint: @cut_endpoint, path: @path])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: PeerResponse)
  end

  @spec put_cut_info(peer :: peer(), network_opts :: network_opts()) ::
          response()
  def put_cut_info(%Peer{} = peer, network_opts \\ []) do
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    location = Keyword.get(network_opts, :location, set_default_location(network_id))
    body = json_request_body(peer)
    headers = [{"Content-Type", "application/json"}]

    :put
    |> Request.new(p2p: [endpoint: @cut_endpoint, path: @path])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_headers(headers)
    |> Request.add_body(body)
    |> Request.perform()
    |> return_response(peer)
  end

  @spec retrieve_mempool_info(network_opts :: network_opts()) :: response()
  def retrieve_mempool_info(network_opts \\ []) do
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    location = Keyword.get(network_opts, :location, set_default_location(network_id))
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])

    :get
    |> Request.new(p2p: [endpoint: @mempool_endpoint, path: @path])
    |> Request.set_network(network_id)
    |> Request.set_chain_id(chain_id)
    |> Request.set_location(location)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: PeerResponse)
  end

  @spec json_request_body(peer :: peer()) :: json()
  defp json_request_body(peer) do
    peer
    |> PeerRequestBody.new()
    |> PeerRequestBody.to_json!()
  end

  @spec return_response(response :: {:ok, map()}, peer :: peer()) :: response()
  defp return_response({:ok, %{response: :no_content, status: 204}}, peer),
    do: {:ok, PeerPutResponse.new(peer)}

  defp return_response({:error, error}, _cut), do: {:error, error}

  @spec set_default_location(network_id :: network_id()) :: location()
  defp set_default_location(:testnet04), do: "us1"
  defp set_default_location(:mainnet01), do: "us-e1"
end
