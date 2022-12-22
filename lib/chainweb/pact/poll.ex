defmodule Kadena.Chainweb.Pact.Poll do
  @moduledoc """
  Send endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{PollRequestBody, PollResponse, Spec}

  @behaviour Spec

  @endpoint "poll"

  @type request_keys :: list(String.t())
  @type json :: String.t()

  @impl true
  def process(request_keys, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(request_keys)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: PollResponse)
  end

  @spec json_request_body(request_keys :: request_keys()) :: json()
  defp json_request_body(request_keys) do
    request_keys
    |> PollRequestBody.new()
    |> PollRequestBody.to_json!()
  end
end
