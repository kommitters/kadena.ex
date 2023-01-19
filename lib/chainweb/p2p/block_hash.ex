defmodule Kadena.Chainweb.P2P.BlockHash do
  @moduledoc """
    BlockHash endpoints implementation for P2P API.
  """

  @endpoint "hash"

  alias Kadena.Chainweb.P2P.{BlockBranchesRequestBody, BlockHashResponse}
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type payload :: Keyword.t()
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
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHashResponse)
  end

  @spec retrieve_branches(payload :: payload(), network_opts :: network_opts()) ::
          response()
  def retrieve_branches(payload \\ [], network_opts \\ []) do
    lower = Keyword.get(payload, :lower, [])
    upper = Keyword.get(payload, :upper, [])
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])
    body = json_request_body(lower: lower, upper: upper)
    headers = [{"Content-Type", "application/json"}]

    :post
    |> Request.new(p2p: [endpoint: @endpoint, path: "branch"])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.add_body(body)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHashResponse)
  end

  @spec json_request_body(payload :: payload()) :: json()
  defp json_request_body(payload) do
    payload
    |> BlockBranchesRequestBody.new()
    |> BlockBranchesRequestBody.to_json!()
  end
end
