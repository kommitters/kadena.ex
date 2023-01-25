defmodule Kadena.Chainweb.P2P.Peer do
  @moduledoc """
  Peer endpoints implementation for P2P API.
  """

  alias Kadena.Chainweb.P2P.PeerResponse
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type network_id :: :testnet04 | :mainnet01
  @type error :: {:error, Error.t()}
  @type location :: String.t()
  @type retrieve_cut_info_response :: {:ok, PeerResponse.t()} | error()

  @cut_endpoint "cut"
  @path "peer"

  @spec retrieve_cut_info(network_opts :: network_opts()) ::
          retrieve_cut_info_response()
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

  @spec set_default_location(network_id :: network_id()) :: location()
  defp set_default_location(:testnet04), do: "us1"
  defp set_default_location(:mainnet01), do: "us-e1"
end
