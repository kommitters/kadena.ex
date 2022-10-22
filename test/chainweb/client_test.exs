defmodule Kadena.Chainweb.CannedClientImpl do
  @moduledoc false

  @behaviour Kadena.Chainweb.Client.Spec

  @impl true
  def request(_method, _path, _chain_id, _headers, _body, _opts) do
    send(self(), {:request, "RESPONSE"})
    :ok
  end
end

defmodule Kadena.Chainweb.ClientTest do
  @moduledoc """
  `Chainweb.Client` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.{CannedClientImpl, Client}

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedClientImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)
  end

  test "request/6" do
    Client.request(:post, "/local")
    assert_receive({:request, "RESPONSE"})
  end
end
