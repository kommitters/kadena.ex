defmodule Kadena.Chainweb.Client.CannedSPVRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"bKT10kNSeAyE4LgfFInhorKpK_tNLcNjsaWgug4v82s\",\"targetChainId\":\"1\"}",
        _options
      ) do
    response = Chainweb.fixture("spv")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/0/pact/spv",
        _headers,
        "{\"requestKey\":\"Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM\",\"targetChainId\":\"1\"}",
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
        "{\"requestKey\":\"bad_length\",\"targetChainId\":\"1\"}",
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
        "{\"requestKey\":\"hello\",\"targetChainId\":\"1\"}",
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
      target_chain_id: "1",
      request_keys_errors: %{
        length: "bad_length",
        decoding: "hello",
        no_result: "Msx7BoeZE0QpflZKkFhSjDZmvMf4xtZ0OxSL1EOckzM"
      },
      response:
        {:ok,
         %SPVResponse{
           proof:
             "eyJjaGFpbiI6MSwib2JqZWN0IjoiQUFBQUVRQUFBQUFBQUFBRkFNY3duU1VVOC1kbDV6RjI2MndtUFJmdTJtYWdsUXY3LTA3TzF1Um5VTTlnQUlVek9KVXRmTHNBTURnZVNPVUlGUmpZcjlsZGNLSU01LU1YNFRRbHRMRzRBTG1CMUk5ZFRXTkx5Vm1haWpwX0FuOTZjelRrT1Z4cEtPUXdFX3NlVElaUUFlaE9ST3hXQXJCYnV6ZXZ2S01HUGUwdUZVX1BPMnozN1QtLWNLYXQ2dXd6QWFnNUIxN1VDdlFPRHo2SWpsUDB4Mkc3cUdCZzZYakQ0Z1RZLTF3dWtZWWVBTTJMdENBbzJaejQ0U0JTSnZWd2hqNDliYzFfSUc4ZGF6Y3ZLaFpFaGdyX0FVUVg3cXFVV2MtX2licWNaS043TUdlZGdwQ3VIbkoyLTYyOFVPeTNfY0JoQU43enBTaHFlVS1fU1Q3amU2RXRDQVFtdWhWaW5ZRUM1UE5YN1lmMlRxSW5BSVNXdENHZWk3SWhEYUJqTDFkUlREQXlrVDdmUTNUQW5iWUh1dTVLWHljSEFVU1lhSm40SHlXVHFvVFBBSHk5V3VENDh5LWxHSWVKRUJOMHhZLXg3dk1zQUkwLVVyNXViVkVBbFFvUTBBS3pIck40Nm5CeFExRE5oWWdMSXJldG1qOWhBVlV4dndmYUNVeFBzU0ZUWUF0U1JPcF9yZklMYnA5S1gxeDBkTTFKMEh3RUFQbXFaQ0ZzajRiTDJPSTZzaUxkMmJrUmFGUmRNX0hNWWJaZDBOaGpyUXRmQU1NSWFBQzEzbnBETkNQM3FVaU1rdzlFMU0yMXpRLUM1eEFTUTREaGd1R3dBZVV3RW1BRUxDWEFja0gzeExDcGM1ZzdsU0dVaFN5VktfZVFjeUM1RlN2RUFNOW5iWWl1ODNBQnVxMVAydlpta1k5LWJGSTRoTjd5N2FzaldyQXJCeVBVQURTMnV3Y3ZHR2h3Wmx5dlhsaVRQaTFlelJhZ1lQeWowbnJ0LXcwYlFEci0iLCJzdWJqZWN0Ijp7ImlucHV0IjoiQUJSN0ltZGhjeUk2TmpBM0xDSnlaWE4xYkhRaU9uc2ljM1JoZEhWeklqb2ljM1ZqWTJWemN5SXNJbVJoZEdFaU9pSlhjbWwwWlNCemRXTmpaV1ZrWldRaWZTd2ljbVZ4UzJWNUlqb2lZa3RVTVRCclRsTmxRWGxGTkV4blprWkpibWh2Y2t0d1MxOTBUa3hqVG1wellWZG5kV2MwZGpneWN5SXNJbXh2WjNNaU9pSlBVWHBEVEUxSU1IbGpXakJJVUc5T01VWXRNbEpqYVdaak5GSjFValJTYldOUE5uUXlhVXBKTmtFNElpd2laWFpsYm5SeklqcGJleUp3WVhKaGJYTWlPbHNpYXpwak9Ea3haRFkzTmpGbFpESmpOR05qWVdSaVpUWmhNVEUwTWpnd00yWmtNelJtWldSbVpUbGtZakV4TURFME9XTmtNV1E0WlRKaE4ySmpPVEJrWXpKbUlpd2lObVE0TjJaa05tVTFaVFEzTVRnMVkySTBNakUwTlRsa01qZzRPR0prWkdKaE4yRTJZekJtTW1NMFlXVTFNalEyWkRWbU16aG1PVGt6T0RFNFltSTRPU0lzTmk0d04yVXRORjBzSW01aGJXVWlPaUpVVWtGT1UwWkZVaUlzSW0xdlpIVnNaU0k2ZXlKdVlXMWxjM0JoWTJVaU9tNTFiR3dzSW01aGJXVWlPaUpqYjJsdUluMHNJbTF2WkhWc1pVaGhjMmdpT2lKeVJUZEVWVGhxYkZGTU9YaGZUVkJaZFc1cFdrcG1OVWxEUWxSQlJVaEJTVVpSUTBJMFlteHZabEEwSW4xZExDSnRaWFJoUkdGMFlTSTZiblZzYkN3aVkyOXVkR2x1ZFdGMGFXOXVJanB1ZFd4c0xDSjBlRWxrSWpveU1ERTJNREU0TUgwIn0sImFsZ29yaXRobSI6IlNIQTUxMnRfMjU2In0"
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
