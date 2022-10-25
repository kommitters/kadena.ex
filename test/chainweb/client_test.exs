defmodule Kadena.Chainweb.CannedClientImpl do
  @moduledoc false

  @behaviour Kadena.Chainweb.Client.Spec

  @impl true
  def request(_path, _method, _headers, _body, _opts) do
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
    Client.request(
      "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/pact/api/v1/local",
      :post
    )

    assert_receive({:request, "RESPONSE"})
  end
end
