defmodule Kadena.Chainweb.Pact.SPV do
  @moduledoc """
  SPV endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{Spec, SPVRequestBody, SPVResponse}

  @behaviour Spec

  @endpoint "spv"

  @type payload_opts :: list()
  @type json :: String.t()

  @impl true
  def process(payload_opts, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(payload_opts)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: SPVResponse)
  end

  @spec json_request_body(payload_opts :: payload_opts()) :: json()
  defp json_request_body(payload_opts) do
    payload_opts
    |> SPVRequestBody.new()
    |> SPVRequestBody.to_json!()
  end
end
