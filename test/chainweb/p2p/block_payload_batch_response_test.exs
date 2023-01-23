defmodule Kadena.Chainweb.P2P.BlockPayloadBatchResponseTest do
  @moduledoc """
  `BlockPayloadBatchResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockPayloadBatchResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    batch = [
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

    %{
      attrs: Chainweb.fixture("block_payload_retrieve_batch"),
      batch: batch
    }
  end

  test "new/1", %{
    attrs: attrs,
    batch: batch
  } do
    %BlockPayloadBatchResponse{batch: ^batch} = BlockPayloadBatchResponse.new(attrs)
  end
end
