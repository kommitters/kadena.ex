defmodule Kadena.Chainweb.Client.CannedListenRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1/listen",
        _headers,
        "{\"listen\":\"bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s\"}",
        _options
      ) do
    response = Chainweb.fixture("listen")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1/listen",
        _headers,
        "{\"listen\":\"Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM\"}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :timeout
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1/listen",
        _headers,
        "{\"listen\":\"bad_length\"}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Request Key bad_lengtg has incorrect hash of length 7"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/api/v1/listen",
        _headers,
        "{\"listen\":\"hello\"}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $.listen: Base64URL decode failed: invalid padding near offset 4"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.Pact.ListenTest do
  @moduledoc """
  `Listen` endpoint implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedListenRequests
  alias Kadena.Chainweb.{Error, Pact}
  alias Kadena.Chainweb.Pact.ListenResponse

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedListenRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    %{
      request_key: "bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s",
      request_keys_errors: %{
        length: "bad_length",
        decoding: "hello",
        no_result: "Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM"
      },
      response:
        {:ok,
         %ListenResponse{
           continuation: nil,
           events: [
             %{
               module: %{name: "coin", namespace: nil},
               module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
               name: "TRANSFER",
               params: [
                 "k:c891d6761ed2c4ccadbe6a1142803fd34fedfe9db110149cd1d8e2a7bc90dc2f",
                 "6d87fd6e5e47185cb421459d2888bddba7a6c0f2c4ae5246d5f38f993818bb89",
                 6.07e-4
               ]
             }
           ],
           gas: 607,
           logs: "OQzCLMH0ycZ0HPoN1F-2Rcifc4RuR4RmcO6t2iJI6A8",
           meta_data: %{
             block_hash: "eNpIVqyanLWY3sGszNfgYN8YXWXDXfUsWbE_vWcNDlY",
             block_height: 3_281_769,
             block_time: 1_670_883_254_243_347,
             prev_block_hash: "Tw4Z1exNzIinUFe3Y-rrbqp-iMo6NvQJQggMSeVNayw"
           },
           req_key: "bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s",
           result: %{data: "Write succeeded", status: "success"},
           tx_id: 20_160_180
         }}
    }
  end

  test "process/2", %{request_key: request_key, response: response} do
    ^response = Pact.listen(request_key, network_id: :mainnet01, chain_id: 0)
  end

  test "process/2 no result", %{request_keys_errors: %{no_result: no_result}} do
    {:error, %Kadena.Chainweb.Error{status: :network_error, title: :timeout}} =
      Pact.listen(no_result,
        network_id: :mainnet01,
        chain_id: 0
      )
  end

  test "process/2 length error", %{request_keys_errors: %{length: length}} do
    {:error,
     %Error{
       status: 400,
       title: "Request Key bad_lengtg has incorrect hash of length 7"
     }} = Pact.listen(length, network_id: :mainnet01, chain_id: 0)
  end

  test "process/2 decoding error", %{request_keys_errors: %{decoding: decoding}} do
    {:error,
     %Error{
       status: 400,
       title: "Error in $.listen: Base64URL decode failed: invalid padding near offset 4"
     }} = Pact.listen(decoding, network_id: :mainnet01, chain_id: 0)
  end
end
