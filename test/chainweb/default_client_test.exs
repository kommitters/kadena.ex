defmodule Kadena.Chainweb.CannedHTTPClient do
  @moduledoc false

  alias Kadena.Test.Fixtures.Chainweb

  @spec request(
          method :: atom(),
          url :: String.t(),
          headers :: list(),
          body :: String.t(),
          opt :: list()
        ) :: {:ok, non_neg_integer(), list(), String.t()} | {:error, Keyword.t()}
  def request(method, url, headers \\ [], body \\ "", opt \\ [])
  def request(:post, "/not_existing_url", _headers, _body, _opt), do: {:ok, 404, [], ""}
  def request(:post, "/server_error_mock", _headers, _body, _opt), do: {:ok, 500, [], ""}
  def request(:post, "/url_not_authorized", _headers, _body, _opt), do: {:ok, 401, [], ""}
  def request(:post, _url, _headers, "", _opt), do: {:ok, 400, [], "not enough input"}
  def request(:post, _url, [], _body, _opt), do: {:ok, 400, [], ""}
  def request(:get, _url, _headers, _body, _opt), do: {:ok, 405, [], ""}

  def request(:post, _url, _headers, _body, [:with_body, follow_redirect: true, recv_timeout: 1]),
    do: {:error, :timeout}

  def request(:post, _url, _headers, _body, _opt) do
    json_body = Chainweb.fixture("200", raw_data: true)
    {:ok, 200, [], json_body}
  end
end

defmodule Kadena.Chainweb.DefaultClientTest do
  use ExUnit.Case

  alias Kadena.Chainweb.{CannedHTTPClient, Client, Error}

  setup do
    Application.put_env(:kadena, :http_client, CannedHTTPClient)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client)
    end)

    %{
      url: "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/pact/api/v1",
      header: [{"Content-Type", "application/json"}],
      body:
        "{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"\\\",\\\"creationTime\\\":0,\\\"gasLimit\\\":10,\\\"gasPrice\\\":0,\\\"sender\\\":\\\"\\\",\\\"ttl\\\":0},\\\"networkId\\\":null,\\\"nonce\\\":\\\"\\\\\\\"step01\\\\\\\"\\\",\\\"payload\\\":{\\\"cont\\\":null,\\\"exec\\\":{\\\"code\\\":\\\"(+ 2 3)\\\",\\\"data\\\":{\\\"accountsAdminKeyset\\\":[\\\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\\\"]}}},\\\"signers\\\":[]}\",\"hash\":\"jr6N7jQ9nVH0A_gRxe3RfKxR7rHn-IG-GosWz6WnMXQ\",\"sigs\":[]}"
    }
  end

  describe "request/6" do
    test "success", %{url: url, header: header, body: body} do
      {:ok,
       %{
         result: %{
           status: "success",
           data: 5
         }
       }} = Client.request(:post, url <> "/local", header, body)
    end

    test "with an invalid body", %{url: url, header: header} do
      {:error, %Error{status: 400, title: "not enough input"}} =
        Client.request(:post, url <> "/local", header)
    end

    test "with an invalid url", %{body: body} do
      {:error, %Error{status: 404, title: "not found"}} =
        Client.request(:post, "/not_existing_url", [], body)
    end

    test "without header", %{url: url, body: body} do
      {:error, %Error{status: 400, title: "bad request"}} =
        Client.request(:post, url <> "/local", [], body)
    end

    test "with an unauthorized access", %{header: header, body: body} do
      {:error, %Error{status: 401, title: "unauthorized"}} =
        Client.request(:post, "/url_not_authorized", header, body)
    end

    test "with an not existing url", %{header: header, body: body} do
      {:error, %Error{status: 404, title: "not found"}} =
        Client.request(:post, "/not_existing_url", header, body)
    end

    test "with a server error", %{header: header, body: body} do
      {:error, %Error{status: 500, title: "server error"}} =
        Client.request(:post, "/server_error_mock", header, body)
    end

    test "with an invalid method", %{url: url, header: header, body: body} do
      {:error, %Error{status: 405, title: "method not allowed"}} =
        Client.request(:get, url <> "/local", header, body)
    end

    test "timeout", %{url: url, header: header, body: body} do
      {:error, %Error{status: :network_error, title: :timeout}} =
        Client.request(:post, url <> "/local", header, body, recv_timeout: 1)
    end
  end
end
