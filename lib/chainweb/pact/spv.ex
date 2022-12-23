defmodule Kadena.Chainweb.Pact.SPV do
  @moduledoc """
  SPV endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{SPVResponse, SPVRequestBody, Spec}

  @behaviour Spec

  @endpoint "spv"

  @type payload_options :: list()
  @type json :: String.t()

  @impl true
  def process(payload_options, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(payload_options)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: SPVResponse)
  end

  @spec json_request_body(payload_options :: payload_options()) :: json()
  defp json_request_body(payload_options) do
    payload_options
    |> SPVRequestBody.new()
    |> SPVRequestBody.to_json!()
    |> IO.inspect()
  end
end
