defmodule Kadena.Chainweb.P2P.Cut do
  @moduledoc """
  Cut endpoints implementation for P2P API.
  """

  @endpoint "cut"

  alias Kadena.Chainweb.P2P.{CutRequestBody, CutResponse}
  alias Kadena.Chainweb.{Error, Request}

  @type network_opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type cut_response :: CutResponse.t()
  @type retrieve_response :: cut_response() | error()
  @type payload_opts :: Keyword.t()
  @type origin :: map() | nil
  @type publish_response :: {:ok, map} | error()
  @type json :: String.t()

  @spec retrieve(network_opts :: network_opts()) :: retrieve_response()
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

  @spec publish(payload_opts :: payload_opts(), network_opts :: network_opts()) ::
          publish_response()
  def publish(payload_opts \\ [], network_opts \\ []) do
    location = Keyword.get(network_opts, :location)
    network_id = Keyword.get(network_opts, :network_id, :testnet04)
    payload = Keyword.get(payload_opts, :payload)
    origin = Keyword.get(payload_opts, :origin)
    body = json_request_body(payload, origin)
    headers = [{"Content-Type", "application/json"}]

    :put
    |> Request.new(p2p: [endpoint: @endpoint])
    |> Request.set_network(network_id)
    |> Request.set_location(location)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
  end

  @spec json_request_body(payload :: cut_response(), origin :: origin()) :: json()
  defp json_request_body(payload, origin) do
    payload
    |> CutRequestBody.new()
    |> CutRequestBody.set_origin(origin)
    |> CutRequestBody.to_json!()
  end
end
