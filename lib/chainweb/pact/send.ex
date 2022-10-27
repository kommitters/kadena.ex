defmodule Kadena.Chainweb.Pact.Send do
  @moduledoc """
  Send endpoint implementation for `Chainweb.Pact` contracts.
  """

  alias Kadena.Types.{SendRequestBody, SendResponse}
  alias Kadena.Chainweb.{Client, Util.Network}

  @behaviour Kadena.Chainweb.Pact.Request

  @impl true
  def process(%SendRequestBody{} = request, network \\ :test, chain_id \\ "0") do
    url = Network.base_url(network, chain_id)
    headers = Network.base_headers()

    request
    |> prepare()
    |> (&Client.request(:post, url <> "/send", headers, &1)).()
    |> case do
      {:error, reason} -> {:error, reason}
      result -> SendResponse.new(result)
    end
  end

  @impl true
  def prepare(%SendRequestBody{json: json}), do: json
end
