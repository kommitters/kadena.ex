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

  def request(:get, _url, [{"Content-Type", "application/octet-stream"}], _body, _opt),
    do: {:ok, 200, [{"Content-Type", "application/octet-stream"}], <<0, 0, 0, 0, 0, 0, 0, 0>>}

  def request(:get, _url, _headers, _body, _opt), do: {:ok, 405, [], ""}

  def request(:post, _url, _headers, _body, [:with_body, follow_redirect: true, recv_timeout: 1]),
    do: {:error, :timeout}

  def request(:post, _url, _headers, _body, _opt) do
    json_body = Chainweb.fixture("200", raw_data: true)
    {:ok, 200, [], json_body}
  end

  def request(:put, _url, _headers, _body, _opt), do: {:ok, 204, [], :no_content}
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
      cut_url: "https://us-e2.chainweb.com/chainweb/0.0/mainnet01/cut",
      url_for_binary:
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
      header: [{"Content-Type", "application/json"}],
      header_octet: [{"Content-Type", "application/octet-stream"}],
      body:
        "{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"\\\",\\\"creationTime\\\":0,\\\"gasLimit\\\":10,\\\"gasPrice\\\":0,\\\"sender\\\":\\\"\\\",\\\"ttl\\\":0},\\\"networkId\\\":null,\\\"nonce\\\":\\\"\\\\\\\"step01\\\\\\\"\\\",\\\"payload\\\":{\\\"cont\\\":null,\\\"exec\\\":{\\\"code\\\":\\\"(+ 2 3)\\\",\\\"data\\\":{\\\"accountsAdminKeyset\\\":[\\\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\\\"]}}},\\\"signers\\\":[]}\",\"hash\":\"jr6N7jQ9nVH0A_gRxe3RfKxR7rHn-IG-GosWz6WnMXQ\",\"sigs\":[]}",
      cut_body:
        "{\"hashes\":{\"0\":{\"hash\":\"N5oyYlCvq6VvyoqioTQClWXAudf_ap3gqXxSpr4V32w\",\"height\":3362200},\"1\":{\"hash\":\"CK2XPSueEx8EdkIehFMUadEBnMKZTPOfgM5-fEyoYbw\",\"height\":3362200},\"10\":{\"hash\":\"96YYw5pRg4MBjkNFDl9Xp7jHbOnagJMj7X5dCqZ60XU\",\"height\":3362200},\"11\":{\"hash\":\"pFUCltdbMKaPNIbD5UmYPOlI39JGPKB5btukDg0UDu4\",\"height\":3362199},\"12\":{\"hash\":\"DUmXlz012BHJ4E_yrer4KreqjJLFbt9MBshgJ_et6TA\",\"height\":3362200},\"13\":{\"hash\":\"FjR3WBYQDaDvSiiq56gyV71DZrBiu83zupTbfBG_-ig\",\"height\":3362199},\"14\":{\"hash\":\"gmNKndByH1bTC-3Ta_v387x1E-7esY9Vn3vYPcWr-vw\",\"height\":3362200},\"15\":{\"hash\":\"jFrXJGikDL71aLn4g6HP4hDQKWQFYSIFjdca4__pu2c\",\"height\":3362200},\"16\":{\"hash\":\"WEVmzdin0Rb5WAlYczcIWOFtyzSZQosVFGaqbhbQ-N8\",\"height\":3362200},\"17\":{\"hash\":\"GBOnwWBFpKzMRbfixDwWTMcM2ViLld0EAVdnmgWsbx8\",\"height\":3362200},\"18\":{\"hash\":\"-B6DtXsobMyJ2kQHr60CHMskur6pA7snFu140Utiyzk\",\"height\":3362199},\"19\":{\"hash\":\"dWJGDWMSqqHiTjKKKPlSTegNqF3oGFURslo43hs-WtM\",\"height\":3362200},\"2\":{\"hash\":\"Mh2UjcEWgqYoyueYlq2tGa136cq3V4OOg7bmYHdfebI\",\"height\":3362200},\"3\":{\"hash\":\"rzXbneFCATH1XTPbCrGlFBFQGkKV5PNzOW7F2IRiCsE\",\"height\":3362198},\"4\":{\"hash\":\"SMDq8UsGZBR1JL9uiPIjzWgqzQg0uGB2QhmgJb3nt7k\",\"height\":3362200},\"5\":{\"hash\":\"WlkYOwmc8ToRsPb6RBl814R-RdhpL4rw5sBbW98d414\",\"height\":3362199},\"6\":{\"hash\":\"khQSsOZvKQCickhbp19ovrpIQNYQgCc9oAJ2veSxt6c\",\"height\":3362199},\"7\":{\"hash\":\"EdsyQ0S5O1zNYZ5TBS7VnwstBwaaSFoWR1JSaLt6ESU\",\"height\":3362200},\"8\":{\"hash\":\"9eexjG99ScAoMkxrEmtVPAMEis0ZsY_05ZBVyj1hdP8\",\"height\":3362199},\"9\":{\"hash\":\"uAB0hM5bNmvXbtvuohcXH6DSX6bnZ3yGhdTJvvBYzC4\",\"height\":3362200}},\"height\":67243992,\"id\":\"PXbSJgmFjN3A4DSz37ttYWmyrpDfzCoyivVflV3VL9A\",\"instance\":\"mainnet01\",\"origin\":{\"address\":{\"hostname\":\"hetzner-eu-13-58.poolmon.net\",\"port\":4443},\"id\":\"VsCK48567Tu5v4NucnGiB7Wp6QSf2K2UjiBbxW_XSgE\"},\"weight\":\"zrmhnWgsJ-5v9gMAAAAAAAAAAAAAAAAAAAAAAAAAAAA\"}",
      binary: <<0, 0, 0, 0, 0, 0, 0, 0>>
    }
  end

  describe "request/5" do
    test "success", %{url: url, header: header, body: body} do
      {:ok,
       %{
         result: %{
           status: "success",
           data: 5
         }
       }} = Client.request(:post, url <> "/local", header, body)
    end

    test "success 204", %{cut_url: cut_url, header: header, cut_body: cut_body} do
      {:ok, %{status: 204, response: :no_content}} =
        Client.request(:put, cut_url, header, cut_body)
    end

    test "success when waiting a binary response", %{
      url_for_binary: url_for_binary,
      header_octet: header_octet,
      binary: binary
    } do
      {:ok, ^binary} = Client.request(:get, url_for_binary, header_octet)
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
