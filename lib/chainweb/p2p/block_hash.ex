defmodule Kadena.Chainweb.P2P.BlockHash do
  @moduledoc """
    BlockHash endpoints implementation for P2P API.
  """

  @endpoint "hash"

  alias Kadena.Chainweb.P2P.BlockHashResponse
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type block_hash_response :: BlockHashResponse.t()
  @type retrieve_response :: block_hash_response | error()

  @spec retrieve(network_opts :: network_opts()) :: retrieve_response()
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
end
