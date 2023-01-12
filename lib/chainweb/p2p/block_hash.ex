defmodule Kadena.Chainweb.P2P.BlockHash do
  @moduledoc """
    BlockHash endpoints implementation for P2P API.
  """

  @endpoints [get: "hash", post: "hash/branch"]

  alias Kadena.Chainweb.P2P.{BlockHashRequestBody, BlockHashResponse}
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type payload_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type response :: BlockHashResponse.t() | error()
  @type json :: String.t()

  @spec retrieve(network_opts :: network_opts()) :: response()
  def retrieve(network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])

    :get
    |> Request.new(p2p: [endpoint: @endpoints[:get]])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHashResponse)
  end

  @spec retrieve_branches(payload_opts :: payload_opts(), network_opts :: network_opts()) ::
          response()
  def retrieve_branches(payload_opts \\ [], network_opts \\ []) do
    lower = Keyword.get(payload_opts, :lower, [])
    upper = Keyword.get(payload_opts, :upper, [])
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])
    body = json_request_body(lower: lower, upper: upper)
    headers = [{"Content-Type", "application/json"}]

    :post
    |> Request.new(p2p: [endpoint: @endpoints[:post]])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.add_body(body)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHashResponse)
  end

  @spec json_request_body(payload :: payload_opts()) :: json()
  defp json_request_body(payload) do
    payload
    |> BlockHashRequestBody.new()
    |> BlockHashRequestBody.to_json!()
  end
end
