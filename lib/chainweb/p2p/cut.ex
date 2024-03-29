defmodule Kadena.Chainweb.P2P.Cut do
  @moduledoc """
  Cut endpoints implementation for P2P API.
  """

  @endpoint "cut"

  alias Kadena.Chainweb.P2P.{CutRequestBody, CutResponse}
  alias Kadena.Chainweb.{Cut, Error, Request}

  @type network_opts :: Keyword.t()
  @type network_id :: :mainnet01 | :testnet04
  @type error :: {:error, Error.t()}
  @type response :: {:ok, CutResponse.t()} | error()
  @type cut :: Cut.t()
  @type origin :: map() | nil
  @type json :: String.t()
  @type location :: String.t()

  @spec retrieve(network_opts :: network_opts()) :: response()
  def retrieve(network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    query_params = Keyword.get(network_opts, :query_params, [])

    :get
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_query(query_params)
    |> Request.perform()
    |> Request.results(as: CutResponse)
  end

  @spec publish(cut :: cut(), network_opts :: network_opts()) :: response()
  def publish(%Cut{} = cut, network_opts \\ []) do
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    location = Keyword.get(network_opts, :location, set_default_location(network_id))
    body = json_request_body(cut)
    headers = [{"Content-Type", "application/json"}]

    :put
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> return_response(cut)
  end

  @spec json_request_body(cut :: cut()) :: json()
  defp json_request_body(cut) do
    cut
    |> CutRequestBody.new()
    |> CutRequestBody.to_json!()
  end

  @spec set_default_location(network_id :: network_id()) :: location()
  defp set_default_location(:testnet04), do: "us1"
  defp set_default_location(:mainnet01), do: "us-e1"

  @spec return_response(response :: {:ok, map()}, cut :: cut()) :: response()
  defp return_response({:ok, %{response: :no_content, status: 204}}, cut),
    do: {:ok, CutResponse.new(cut)}

  defp return_response({:error, error}, _cut), do: {:error, error}
end
