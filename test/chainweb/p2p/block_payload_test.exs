defmodule Kadena.Chainweb.Client.CannedBlockPayloadRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_payload_retrieve")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/invalid",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "DecodeException \"not enough bytes\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/20/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title:
             "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/batch",
        _headers,
        "[\"tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg\",\"EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4\"]",
        _options
      ) do
    response = Chainweb.fixture("block_payload_retrieve_batch")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/batch",
        _headers,
        "[\"ññññM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $[0]: Base64DecodeException \"invalid base64 encoding near offset 0\""
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/batch",
        _headers,
        "\"invalid\"",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $: parsing [] failed, expected Array, but encountered String"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/payload/batch",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/20/payload/batch",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0/outputs",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_payload_retrieve_with_outputs")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/invalid/outputs",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "DecodeException \"not enough bytes\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/20/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0/outputs",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777/outputs",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title:
             "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/payload/R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0/outputs",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/outputs/batch",
        _headers,
        "[\"tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg\",\"EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4\"]",
        _options
      ) do
    response = Chainweb.fixture("block_payload_batch_with_outputs")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/outputs/batch",
        _headers,
        "[\"ññññM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $[0]: Base64DecodeException \"invalid base64 encoding near offset 0\""
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/payload/outputs/batch",
        _headers,
        "\"invalid\"",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "Error in $: parsing [] failed, expected Array, but encountered String"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/payload/outputs/batch",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/20/payload/outputs/batch",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.P2P.BlockPayloadTest do
  @moduledoc """
  `BlockPayload` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedBlockPayloadRequests
  alias Kadena.Chainweb.Error

  alias Kadena.Chainweb.P2P.{
    BlockPayload,
    BlockPayloadBatchResponse,
    BlockPayloadBatchWithOutputsResponse,
    BlockPayloadResponse,
    BlockPayloadWithOutputsResponse
  }

  describe "retrieve/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockPayloadRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      success_response =
        {:ok,
         %BlockPayloadResponse{
           miner_data:
             "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
           outputs_hash: "Ph2jHKpKxXh5UFOfU7L8_Zb-8I91WlQtCzfn6UTC5cU",
           payload_hash: "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
           transactions: [],
           transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
         }}

      %{
        payload_hash: "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
        non_exisitent_payload_hash: "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777",
        success_response: success_response
      }
    end

    test "success", %{
      success_response: success_response,
      payload_hash: payload_hash
    } do
      ^success_response = BlockPayload.retrieve(payload_hash)
    end

    test "error with an non existing payload_hash", %{
      non_exisitent_payload_hash: non_exisitent_payload_hash
    } do
      {:error,
       %Error{
         status: 404,
         title:
           "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
       }} = BlockPayload.retrieve(non_exisitent_payload_hash)
    end

    test "error with an invalid payload_hash" do
      {:error, %Error{status: 400, title: "DecodeException \"not enough bytes\""}} =
        BlockPayload.retrieve("invalid")
    end

    test "error with an invalid chain_id", %{payload_hash: payload_hash} do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockPayload.retrieve(payload_hash, network_id: :mainnet01, chain_id: "20")
    end

    test "error with a non existing location", %{payload_hash: payload_hash} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        BlockPayload.retrieve(payload_hash, location: "col1", network_id: :mainnet01)
    end
  end

  describe "retrieve_batch/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockPayloadRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      payload_hashes = [
        "tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg",
        "EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4"
      ]

      success_response =
        {:ok,
         %BlockPayloadBatchResponse{
           batch: [
             %{
               miner_data:
                 "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
               outputs_hash: "mAf5H9c4D8j3s6FhIlOdZgrvoffwnhrBM20zzhOK5SA",
               payload_hash: "tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg",
               transactions: [],
               transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
             },
             %{
               miner_data:
                 "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
               outputs_hash: "KG91xchUDjg0z9HPbe8u1_8q-aotv1e2Q1QtMIqII2c",
               payload_hash: "EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4",
               transactions: [],
               transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
             }
           ]
         }}

      %{
        payload_hashes: payload_hashes,
        success_response: success_response
      }
    end

    test "success", %{
      success_response: success_response,
      payload_hashes: payload_hashes
    } do
      ^success_response = BlockPayload.retrieve_batch(payload_hashes)
    end

    test "decode error with an invalid payload_hashes" do
      {:error,
       %Error{
         status: 400,
         title: "Error in $[0]: Base64DecodeException \"invalid base64 encoding near offset 0\""
       }} = BlockPayload.retrieve_batch(["ññññM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774"])
    end

    test "parsing error with an invalid payload_hashes" do
      {:error,
       %Error{
         status: 400,
         title: "Error in $: parsing [] failed, expected Array, but encountered String"
       }} = BlockPayload.retrieve_batch("invalid")
    end

    test "error with an invalid chain_id", %{payload_hashes: payload_hashes} do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockPayload.retrieve_batch(payload_hashes, chain_id: "20")
    end

    test "error with a non existing location", %{payload_hashes: payload_hashes} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        BlockPayload.retrieve_batch(payload_hashes, location: "col1", network_id: :mainnet01)
    end
  end

  describe "with_outputs/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockPayloadRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      success_response =
        {:ok,
         %BlockPayloadWithOutputsResponse{
           coinbase:
             "eyJnYXMiOjAsInJlc3VsdCI6eyJzdGF0dXMiOiJzdWNjZXNzIiwiZGF0YSI6IldyaXRlIHN1Y2NlZWRlZCJ9LCJyZXFLZXkiOiJJak5sU0RFeGRrbGZkMXAxVUROc1JVdGphV3htUTNnNE9WOXJXamM0YmtaMVNrcGlkSGswTkdsT1FtOGkiLCJsb2dzIjoiUkFuWnh1S2NfaFNrZU5OVHBZQUZFVDZTS1BDWVVhczRvOUlEVl92MlNPayIsIm1ldGFEYXRhIjpudWxsLCJjb250aW51YXRpb24iOm51bGwsInR4SWQiOjEwfQ",
           miner_data:
             "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
           outputs_hash: "Ph2jHKpKxXh5UFOfU7L8_Zb-8I91WlQtCzfn6UTC5cU",
           payload_hash: "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
           transactions: [],
           transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
         }}

      %{
        payload_hash: "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
        non_exisitent_payload_hash: "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777",
        success_response: success_response
      }
    end

    test "success", %{
      success_response: success_response,
      payload_hash: payload_hash
    } do
      ^success_response = BlockPayload.with_outputs(payload_hash)
    end

    test "error with a non existing payload_hash", %{
      non_exisitent_payload_hash: non_exisitent_payload_hash
    } do
      {:error,
       %Error{
         status: 404,
         title:
           "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
       }} = BlockPayload.with_outputs(non_exisitent_payload_hash)
    end

    test "error with an invalid payload_hash" do
      {:error, %Error{status: 400, title: "DecodeException \"not enough bytes\""}} =
        BlockPayload.with_outputs("invalid")
    end

    test "error with an invalid chain_id", %{payload_hash: payload_hash} do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockPayload.with_outputs(payload_hash, network_id: :mainnet01, chain_id: "20")
    end

    test "error with a non existing location", %{payload_hash: payload_hash} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        BlockPayload.with_outputs(payload_hash, location: "col1", network_id: :mainnet01)
    end
  end

  describe "batch_with_outputs/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockPayloadRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      payload_hashes = [
        "tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg",
        "EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4"
      ]

      success_response =
        {:ok,
         %BlockPayloadBatchWithOutputsResponse{
           batch: [
             %{
               coinbase:
                 "eyJnYXMiOjAsInJlc3VsdCI6eyJzdGF0dXMiOiJzdWNjZXNzIiwiZGF0YSI6IldyaXRlIHN1Y2NlZWRlZCJ9LCJyZXFLZXkiOiJJazAwWkc5RUxXcE5TSGw0YVRSVWRtWkNSRlY1TTNnNVZrMXJZMHg0WjI1d2FuUjJZbUprTUhsVlVVRWkiLCJsb2dzIjoiYk9JYUNPWk9fYU5ZTmhEMTBuZGFYTnpod3FBTUotdEhWcWp0eVNmZjBWWSIsIm1ldGFEYXRhIjpudWxsLCJjb250aW51YXRpb24iOm51bGwsInR4SWQiOjExfQ",
               miner_data:
                 "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
               outputs_hash: "mAf5H9c4D8j3s6FhIlOdZgrvoffwnhrBM20zzhOK5SA",
               payload_hash: "tD9gYGoTZX1TktM_V61deSQ7pi5N8DP-bPgeyOkf4cg",
               transactions: [],
               transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
             },
             %{
               coinbase:
                 "eyJnYXMiOjAsInJlc3VsdCI6eyJzdGF0dXMiOiJzdWNjZXNzIiwiZGF0YSI6IldyaXRlIHN1Y2NlZWRlZCJ9LCJyZXFLZXkiOiJJalJyWVVrMVYyc3RkRE50ZGs1YWIwSnRWa1ZEWW10ZmVHZGxOVk4xYW5KV2FERnpPRk10UjBWVFMwa2kiLCJsb2dzIjoidHBJUG8zR3g0QXV6QjFZRk9jWEhyTVU3R1lmaW9BcEp6YWNVSjVqc0RvWSIsIm1ldGFEYXRhIjpudWxsLCJjb250aW51YXRpb24iOm51bGwsInR4SWQiOjEyfQ",
               miner_data:
                 "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19",
               outputs_hash: "KG91xchUDjg0z9HPbe8u1_8q-aotv1e2Q1QtMIqII2c",
               payload_hash: "EZtAeZN3UdsNsHP2v8hQ3s5uPl0u_G0juWrVIu1XqQ4",
               transactions: [],
               transactions_hash: "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
             }
           ]
         }}

      %{
        payload_hashes: payload_hashes,
        success_response: success_response
      }
    end

    test "success", %{
      success_response: success_response,
      payload_hashes: payload_hashes
    } do
      ^success_response = BlockPayload.batch_with_outputs(payload_hashes)
    end

    test "decode error with an invalid payload_hashes" do
      {:error,
       %Error{
         status: 400,
         title: "Error in $[0]: Base64DecodeException \"invalid base64 encoding near offset 0\""
       }} = BlockPayload.batch_with_outputs(["ññññM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774"])
    end

    test "parsing error with an invalid payload_hashes" do
      {:error,
       %Error{
         status: 400,
         title: "Error in $: parsing [] failed, expected Array, but encountered String"
       }} = BlockPayload.batch_with_outputs("invalid")
    end

    test "error with an invalid chain_id", %{payload_hashes: payload_hashes} do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockPayload.batch_with_outputs(payload_hashes, chain_id: "20")
    end

    test "error with a non existing location", %{payload_hashes: payload_hashes} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        BlockPayload.batch_with_outputs(payload_hashes, location: "col1", network_id: :mainnet01)
    end
  end
end
