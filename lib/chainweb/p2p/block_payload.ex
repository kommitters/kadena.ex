defmodule Kadena.Chainweb.P2P.BlockPayload do
  @moduledoc """
  BlockPayload endpoints implementation for P2P API.
  """

  @endpoint "payload"

  alias Kadena.Chainweb.P2P.BlockPayloadResponse
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type response :: {:ok, BlockPayloadResponse.t()} | error()

  @spec retrieve(payload_hash :: String.t(), network_opts :: network_opts()) :: response()
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
end
