defmodule Kadena.Chainweb.P2P.BlockPayloadWithOutputsResponseTest do
  @moduledoc """
  `BlockPayloadWithOutputsResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockPayloadWithOutputsResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    transactions = []

    miner_data =
      "eyJhY2NvdW50IjoidXMxIiwicHJlZGljYXRlIjoia2V5cy1hbGwiLCJwdWJsaWMta2V5cyI6WyJkYjc3Njc5M2JlMGZjZjhlNzZjNzViZGIzNWEzNmU2N2YyOTgxMTFkYzYxNDVjNjY2OTNiMDEzMzE5MmUyNjE2Il19"

    coinbase =
      "eyJnYXMiOjAsInJlc3VsdCI6eyJzdGF0dXMiOiJzdWNjZXNzIiwiZGF0YSI6IldyaXRlIHN1Y2NlZWRlZCJ9LCJyZXFLZXkiOiJJak5sU0RFeGRrbGZkMXAxVUROc1JVdGphV3htUTNnNE9WOXJXamM0YmtaMVNrcGlkSGswTkdsT1FtOGkiLCJsb2dzIjoiUkFuWnh1S2NfaFNrZU5OVHBZQUZFVDZTS1BDWVVhczRvOUlEVl92MlNPayIsIm1ldGFEYXRhIjpudWxsLCJjb250aW51YXRpb24iOm51bGwsInR4SWQiOjEwfQ"

    transactions_hash = "AvpbbrgkfNtMI6Hq0hJWZatbwggEKppNYL5rAXJakrw"
    outputs_hash = "Ph2jHKpKxXh5UFOfU7L8_Zb-8I91WlQtCzfn6UTC5cU"
    payload_hash = "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0"

    %{
      attrs: Chainweb.fixture("block_payload_retrieve_with_outputs"),
      outputs_hash: outputs_hash,
      payload_hash: payload_hash,
      transactions: transactions,
      transactions_hash: transactions_hash,
      miner_data: miner_data,
      coinbase: coinbase
    }
  end

  test "new/1", %{
    attrs: attrs,
    outputs_hash: outputs_hash,
    payload_hash: payload_hash,
    transactions: transactions,
    transactions_hash: transactions_hash,
    miner_data: miner_data,
    coinbase: coinbase
  } do
    %BlockPayloadWithOutputsResponse{
      coinbase: ^coinbase,
      miner_data: ^miner_data,
      outputs_hash: ^outputs_hash,
      payload_hash: ^payload_hash,
      transactions: ^transactions,
      transactions_hash: ^transactions_hash
    } = BlockPayloadWithOutputsResponse.new(attrs)
  end
end
