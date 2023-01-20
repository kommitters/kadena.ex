defmodule Kadena.Chainweb.P2P.BlockPayload do
  @moduledoc """
  BlockPayload endpoints implementation for P2P API.
  """

  alias Kadena.Chainweb.P2P.{
    BlockPayloadBatchResponse,
    BlockPayloadResponse,
    BlockPayloadWithOutputsResponse
  }

  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type payload_hashes :: list(String.t())
  @type retrieve_response :: {:ok, BlockPayloadResponse.t()} | error()
  @type retrieve_batch_response :: {:ok, BlockPayloadBatchResponse.t()} | error()
  @type with_outputs_response :: {:ok, BlockPayloadWithOutputsResponse.t()} | error()
  @type json :: String.t()

  @endpoint "payload"

  @spec retrieve(payload_hash :: String.t(), network_opts :: network_opts()) ::
          retrieve_response()
  def retrieve(payload_hash, network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)

    :get
    |> Request.new(p2p: [endpoint: @endpoint, path: payload_hash])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.perform()
    |> Request.results(as: BlockPayloadResponse)
  end

  @spec retrieve_batch(payload_hashes :: payload_hashes(), network_opts :: network_opts()) ::
          retrieve_batch_response()
  def retrieve_batch(payload_hashes \\ [], network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(payload_hashes)

    :post
    |> Request.new(p2p: [endpoint: @endpoint, path: "batch"])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.add_headers(headers)
    |> Request.add_body(body)
    |> Request.perform()
    |> Request.results(as: BlockPayloadBatchResponse)
  end

  @spec with_outputs(payload_hash :: String.t(), network_opts :: network_opts()) ::
          with_outputs_response()
  def with_outputs(payload_hash, network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    chain_id = Keyword.get(network_opts, :chain_id, 0)

    :get
    |> Request.new(p2p: [endpoint: @endpoint, path: payload_hash, segment: "outputs"])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.set_chain_id(chain_id)
    |> Request.perform()
    |> Request.results(as: BlockPayloadWithOutputsResponse)
  end

  @spec json_request_body(payload_hashes :: payload_hashes()) :: json()
  defp json_request_body(payload_hashes), do: Jason.encode!(payload_hashes)
end
