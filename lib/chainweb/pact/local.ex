defmodule Kadena.Chainweb.Pact.Local do
  @moduledoc """
  Local endpoint implementation
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{LocalRequestBody, LocalResponse, Spec}
  alias Kadena.Types.Command

  @behaviour Spec

  @endpoint "local"

  @type cmd :: Command.t()
  @type json :: String.t()

  @impl true
  def process(%Command{} = cmd, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(cmd)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: LocalResponse)
  end

  @spec json_request_body(cmd :: cmd()) :: json()
  defp json_request_body(cmd) do
    cmd
    |> LocalRequestBody.new()
    |> LocalRequestBody.to_json!()
  end
end
