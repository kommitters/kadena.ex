defmodule Kadena.Chainweb.P2P.BlockHeader do
  @moduledoc """
    BlockHeader endpoints implementation for P2P API.
  """

  alias Kadena.Chainweb.P2P.{
    BlockBranchesRequestBody,
    BlockHeaderByHashResponse,
    BlockHeaderResponse
  }

  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type json :: String.t()
  @type payload :: Keyword.t()
  @type retrieve_response :: BlockHeaderResponse.t() | error()
  @type retrieve_by_hash_response :: BlockHeaderByHashResponse.t() | error()

  @endpoint "header"
  @headers [
    encode: "application/json",
    decode: "application/json;blockheader-encoding=object",
    binary: "application/octet-stream"
  ]

  @spec retrieve(network_opts :: network_opts()) :: retrieve_response()
  def retrieve(network_opts \\ []) do
    format = Keyword.get(network_opts, :format, :encode)
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])
    headers = [{"Accept", @headers[format]}]

    :get
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHeaderResponse)
  end

  @spec retrieve_by_hash(block_hash :: String.t(), network_opts :: network_opts()) ::
          retrieve_by_hash_response()
  def retrieve_by_hash(block_hash, network_opts \\ []) do
    format = Keyword.get(network_opts, :format, :encode)
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    headers = [{"Accept", @headers[format]}]

    :get
    |> Request.new(p2p: [endpoint: @endpoint, path: block_hash])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: BlockHeaderByHashResponse)
  end

  @spec retrieve_branches(payload :: payload(), network_opts :: network_opts()) ::
          retrieve_response()
  def retrieve_branches(payload \\ [], network_opts \\ []) do
    lower = Keyword.get(payload, :lower, [])
    upper = Keyword.get(payload, :upper, [])
    format = Keyword.get(network_opts, :format, :encode)
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    query_params = Keyword.get(network_opts, :query_params, [])
    body = json_request_body(lower: lower, upper: upper)
    headers = [{"Content-Type", "application/json"}, {"Accept", @headers[format]}]

    :post
    |> Request.new(p2p: [endpoint: @endpoint, path: "branch"])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.add_body(body)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: BlockHeaderResponse)
  end

  @spec json_request_body(payload :: payload()) :: json()
  defp json_request_body(payload) do
    payload
    |> BlockBranchesRequestBody.new()
    |> BlockBranchesRequestBody.to_json!()
  end
end
