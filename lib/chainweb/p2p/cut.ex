defmodule Kadena.Chainweb.P2P.Cut do
  @moduledoc """
  Cut endpoints implementation for P2P API.
  """

  @endpoint "cut"

  alias Kadena.Chainweb.P2P.CutResponse
  alias Kadena.Chainweb.{Error, Request}

  @type opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type cut_response :: CutResponse.t() | error()

  @spec retrieve(opts :: opts()) :: cut_response()
  def retrieve(opts \\ [])

  def retrieve(opts) do
    location = Keyword.get(opts, :location)
    network_id = Keyword.get(opts, :network_id, :testnet04)
    query_params = Keyword.get(opts, :query_params, [])

    :get
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: CutResponse)
  end
end
