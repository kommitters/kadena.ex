defmodule Kadena.Chainweb.P2P.BlockPayloadBatchWithOutputsResponseTest do
  @moduledoc """
  `BlockPayloadBatchWithOutputsResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockPayloadBatchWithOutputsResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    batch = [
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

    %{
      attrs: Chainweb.fixture("block_payload_batch_with_outputs"),
      batch: batch
    }
  end

  test "new/1", %{
    attrs: attrs,
    batch: batch
  } do
    %BlockPayloadBatchWithOutputsResponse{batch: ^batch} =
      BlockPayloadBatchWithOutputsResponse.new(attrs)
  end
end
