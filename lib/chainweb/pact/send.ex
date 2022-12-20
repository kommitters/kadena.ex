defmodule Kadena.Chainweb.Pact.Send do
  @moduledoc """
  Send endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{SendRequestBody, SendResponse, Spec}
  alias Kadena.Types.Command

  @behaviour Spec

  @endpoint "send"

  @type cmds :: list(Command.t())
  @type json :: String.t()

  @impl true
  def process([%Command{} | _tail] = cmds, network_id: network_id, chain_id: chain_id) do
    headers = [{"Content-Type", "application/json"}]
    body = json_request_body(cmds)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network_id)
    |> Request.add_body(body)
    |> Request.add_headers(headers)
    |> Request.perform()
    |> Request.results(as: SendResponse)
  end

  @spec json_request_body(cmds :: cmds()) :: json()
  defp json_request_body(cmds) do
    cmds
    |> SendRequestBody.new()
    |> SendRequestBody.to_json!()
  end
end
