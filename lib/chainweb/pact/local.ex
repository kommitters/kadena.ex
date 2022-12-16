defmodule Kadena.Chainweb.Pact.Local do
  @moduledoc """
  Send endpoint implementation
  """

  alias Kadena.Chainweb.Request
  alias Kadena.Chainweb.Pact.{Endpoints, JSONPayload, LocalResponse}
  alias Kadena.Types.{Command, LocalRequestBody}

  @type cmd :: Command.t()
  @type json_request_body :: String.t()
  @behaviour Endpoints

  @endpoint "local"
  @headers [{"Content-Type", "application/json"}]

  @impl true
  def process(%Command{} = cmd, network, chain_id) do
    request_body = get_json_request_body(cmd)

    :post
    |> Request.new(pact: [endpoint: @endpoint])
    |> Request.set_chain_id(chain_id)
    |> Request.set_network(network)
    |> Request.add_body(request_body)
    |> Request.add_headers(@headers)
    |> Request.perform()
    |> Request.results(as: LocalResponse)
  end

  def process(_cmds, _network, _chain_id), do: {:error, [command: :invalid_command]}

  @spec get_json_request_body(cmd :: cmd()) :: json_request_body()
  defp get_json_request_body(cmd) do
    cmd
    |> LocalRequestBody.new()
    |> JSONPayload.parse()
  end
end
