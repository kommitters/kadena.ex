defmodule Kadena.Chainweb.Client do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Kadena network.
  """
  alias Kadena.Chainweb.Client

  @behaviour Client.Spec

  @impl true
  def request(method, url, headers \\ [], body \\ "", opts \\ []),
    do: impl().request(method, url, headers, body, opts)

  @spec impl() :: atom()
  defp impl do
    Application.get_env(:kadena, :http_client_impl, Client.Default)
  end
end
