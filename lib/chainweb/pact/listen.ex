defmodule Kadena.Chainweb.Pact.Listen do
  @moduledoc """
  Listen endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{ListenRequestBody, ListenResponse, Spec}

  @behaviour Spec

  @endpoint "listen"

  @type request_key :: String.t()
  @type json :: String.t()

  @impl true
  def process(request_key, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(request_key)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: ListenResponse)
  end

  @spec json_request_body(request_key :: request_key()) :: json()
  defp json_request_body(request_key) do
    request_key
    |> ListenRequestBody.new()
    |> ListenRequestBody.to_json!()
  end
end
