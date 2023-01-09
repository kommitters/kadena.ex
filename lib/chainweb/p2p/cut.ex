defmodule Kadena.Chainweb.P2P.Cut do
  @moduledoc """
  Cut endpoints implementation for P2P API.
  """

  @endpoint "cut"

  alias Kadena.Chainweb.P2P.{CutRequestBody, CutResponse}
  alias Kadena.Chainweb.{Error, Request}

  @type opts :: Keyword.t()
  @type error :: {:error, Error.t()}
  @type cut_response :: CutResponse.t() | error()
  @type payload :: CutRequestBody.t()
  @type origin :: map() | nil
  @type json :: String.t()

  @spec retrieve(opts :: opts()) :: cut_response()
  def retrieve(opts \\ []) do
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

  @spec publish(payload :: payload(), origin :: origin(), opts :: opts()) ::
          error() | {:ok, map}
  def publish(payload, origin, opts \\ []) do
    location = Keyword.get(opts, :location)
    network_id = Keyword.get(opts, :network_id, :testnet04)
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

  @spec json_request_body(payload :: payload(), origin :: origin()) :: json()
  defp json_request_body(payload, origin) do
    payload
    |> CutRequestBody.new()
    |> CutRequestBody.set_origin(origin)
    |> CutRequestBody.to_json!()
  end
end
