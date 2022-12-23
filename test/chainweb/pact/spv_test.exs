defmodule Kadena.Chainweb.Client.CannedSPVRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s\",\"targetChainId\":\"0\"}",
        _options
      ) do
    response = Chainweb.fixture("spv")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM\",\"targetChainId\":\"0\"}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Transaction hash not found: \"Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM\""
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"bad_length\",\"targetChainId\":\"0\"}",
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
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"hello\",\"targetChainId\":\"0\"}",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $.requestKey: Base64URL decode failed: invalid padding near offset 4"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.Pact.SPVTest do
  @moduledoc """
  `SPV` endpoint implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedSPVRequests
  alias Kadena.Chainweb.{Error, Pact}
  alias Kadena.Chainweb.Pact.SPVResponse

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedSPVRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    %{
      request_key: "bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s",
      target_chain_id: "0",
      request_keys_errors: %{
        length: "bad_length",
        decoding: "hello",
        no_result: "Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM"
      },
      response:
        {:ok,
         %SPVResponse{
           response:
             "eyJjaGFpbiI6MCwib2JqZWN0IjoiQUFBQUJ3QUFBQUFBQUFBRkFNY3duU1VVOC1kbDV6RjI2MndtUFJmdTJtYWdsUXY3LTA3TzF1Um5VTTlnQUlVek9KVXRmTHNBTURnZVNPVUlGUmpZcjlsZGNLSU01LU1YNFRRbHRMRzRBTG1CMUk5ZFRXTkx5Vm1haWpwX0FuOTZjelRrT1Z4cEtPUXdFX3NlVElaUUFlaE9ST3hXQXJCYnV6ZXZ2S01HUGUwdUZVX1BPMnozN1QtLWNLYXQ2dXd6QWFnNUIxN1VDdlFPRHo2SWpsUDB4Mkc3cUdCZzZYakQ0Z1RZLTF3dWtZWWVBTTJMdENBbzJaejQ0U0JTSnZWd2hqNDliYzFfSUc4ZGF6Y3ZLaFpFaGdyX0FVUVg3cXFVV2MtX2licWNaS043TUdlZGdwQ3VIbkoyLTYyOFVPeTNfY0JoIiwic3ViamVjdCI6eyJpbnB1dCI6IkFCUjdJbWRoY3lJNk5qQTNMQ0p5WlhOMWJIUWlPbnNpYzNSaGRIVnpJam9pYzNWalkyVnpjeUlzSW1SaGRHRWlPaUpYY21sMFpTQnpkV05qWldWa1pXUWlmU3dpY21WeFMyVjVJam9pWWt0VU1UQnJUbE5sUVhsRk5FeG5aa1pKYm1odmNrdHdTMTkwVGt4alRtcHpZVmRuZFdjMGRqZ3ljeUlzSW14dlozTWlPaUpQVVhwRFRFMUlNSGxqV2pCSVVHOU9NVVl0TWxKamFXWmpORkoxVWpSU2JXTlBOblF5YVVwSk5rRTRJaXdpWlhabGJuUnpJanBiZXlKd1lYSmhiWE1pT2xzaWF6cGpPRGt4WkRZM05qRmxaREpqTkdOallXUmlaVFpoTVRFME1qZ3dNMlprTXpSbVpXUm1aVGxrWWpFeE1ERTBPV05rTVdRNFpUSmhOMkpqT1RCa1l6Sm1JaXdpTm1RNE4yWmtObVUxWlRRM01UZzFZMkkwTWpFME5UbGtNamc0T0dKa1pHSmhOMkUyWXpCbU1tTTBZV1UxTWpRMlpEVm1NemhtT1Rrek9ERTRZbUk0T1NJc05pNHdOMlV0TkYwc0ltNWhiV1VpT2lKVVVrRk9VMFpGVWlJc0ltMXZaSFZzWlNJNmV5SnVZVzFsYzNCaFkyVWlPbTUxYkd3c0ltNWhiV1VpT2lKamIybHVJbjBzSW0xdlpIVnNaVWhoYzJnaU9pSnlSVGRFVlRocWJGRk1PWGhmVFZCWmRXNXBXa3BtTlVsRFFsUkJSVWhCU1VaUlEwSTBZbXh2WmxBMEluMWRMQ0p0WlhSaFJHRjBZU0k2Ym5Wc2JDd2lZMjl1ZEdsdWRXRjBhVzl1SWpwdWRXeHNMQ0owZUVsa0lqb3lNREUyTURFNE1IMCJ9LCJhbGdvcml0aG0iOiJTSEE1MTJ0XzI1NiJ9"
         }}
    }
  end

  test "process/2", %{
    request_key: request_key,
    target_chain_id: target_chain_id,
    response: response
  } do
    ^response =
      Pact.spv([request_key: request_key, target_chain_id: target_chain_id],
        network_id: :mainnet01,
        chain_id: 0
      )
  end

  test "process/2 no result", %{
    request_keys_errors: %{no_result: no_result},
    target_chain_id: target_chain_id
  } do
    {:error,
     %Error{
       status: 400,
       title: "Transaction hash not found: \"Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM\""
     }} =
      Pact.spv([request_key: no_result, target_chain_id: target_chain_id],
        network_id: :mainnet01,
        chain_id: 0
      )
  end

  test "process/2 length error", %{
    request_keys_errors: %{length: length},
    target_chain_id: target_chain_id
  } do
    {:error,
     %Error{
       status: 400,
       title: "Request Key bad_lengtg has incorrect hash of length 7"
     }} =
      Pact.spv([request_key: length, target_chain_id: target_chain_id],
        network_id: :mainnet01,
        chain_id: 0
      )
  end

  test "process/2 decoding error", %{
    request_keys_errors: %{decoding: decoding},
    target_chain_id: target_chain_id
  } do
    {:error,
     %Error{
       status: 400,
       title: "Error in $.requestKey: Base64URL decode failed: invalid padding near offset 4"
     }} =
      Pact.spv([request_key: decoding, target_chain_id: target_chain_id],
        network_id: :mainnet01,
        chain_id: 0
      )
  end
end
