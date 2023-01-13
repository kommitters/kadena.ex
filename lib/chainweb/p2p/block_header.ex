defmodule Kadena.Chainweb.P2P.BlockHeader do
  @moduledoc """
    BlockHeader endpoints implementation for P2P API.
  """

  @endpoint "header"
  @headers [encode: "application/json", decode: "application/json;blockheader-encoding=object"]
  alias Kadena.Chainweb.P2P.BlockHeaderResponse
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type retrieve_response :: BlockHeaderResponse.t() | error()

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
end
