defmodule Kadena.Chainweb.P2P.BlockPayloadResponseTest do
  @moduledoc """
  `BlockPayloadResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockPayloadResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    transactions = [
      "eyJoYXNoIjoiMi16Q3dmRFZZR010WHljd2pTLXRlNzh5U3l3T3JXcjNSdUhiQlJnNDdhRSIsInNpZ3MiOlt7InNpZyI6ImZiMTVkNzkyYTNkNDM1MDI5ODJmOGQ1MGUyMzA1NTI5OWEwZjdhMWRmMWE4YjUyMmE5NTMxNWUyZDljY2MyNmE1MzI4M2I5YTNhNDM5ZWE0ZGY4MGM1ZTIwMjg4NDhjNjFhMWY0MGM5OWIyOTYzOWM0NGNkYTgwMzBmYmViYjBjIn1dLCJjbWQiOiJ7XCJuZXR3b3JrSWRcIjpcIm1haW5uZXQwMVwiLFwicGF5bG9hZFwiOntcImV4ZWNcIjp7XCJkYXRhXCI6e30sXCJjb2RlXCI6XCIoY29pbi50cmFuc2ZlciBcXFwiZTc1NzU4ZGQyYTFjNTk2NDRjMjJlMDQyYzZlYzA3NTI2ZWE0ZTU3MTU0ZjlkYmMyMDc2ZThhODRhYzE5NGYzMlxcXCIgXFxcIjQ2NzdhMDllYTE2MDJlNGUwOWZlMDFlYjExOTZjZjQ3YzBmNDRhYTQ0YWFjOTAzZDVmNjFiZTdkYTM0MjUxMjhcXFwiIDMuNzc2KVwifX0sXCJzaWduZXJzXCI6W3tcInB1YktleVwiOlwiZTc1NzU4ZGQyYTFjNTk2NDRjMjJlMDQyYzZlYzA3NTI2ZWE0ZTU3MTU0ZjlkYmMyMDc2ZThhODRhYzE5NGYzMlwiLFwiY2xpc3RcIjpbe1wiYXJnc1wiOltdLFwibmFtZVwiOlwiY29pbi5HQVNcIn0se1wiYXJnc1wiOltcImU3NTc1OGRkMmExYzU5NjQ0YzIyZTA0MmM2ZWMwNzUyNmVhNGU1NzE1NGY5ZGJjMjA3NmU4YTg0YWMxOTRmMzJcIixcIjQ2NzdhMDllYTE2MDJlNGUwOWZlMDFlYjExOTZjZjQ3YzBmNDRhYTQ0YWFjOTAzZDVmNjFiZTdkYTM0MjUxMjhcIiwzLjc3Nl0sXCJuYW1lXCI6XCJjb2luLlRSQU5TRkVSXCJ9XX1dLFwibWV0YVwiOntcImNyZWF0aW9uVGltZVwiOjE2MDIzODI4MTQsXCJ0dGxcIjoyODgwMCxcImdhc0xpbWl0XCI6NjAwLFwiY2hhaW5JZFwiOlwiMFwiLFwiZ2FzUHJpY2VcIjoxLjBlLTUsXCJzZW5kZXJcIjpcImU3NTc1OGRkMmExYzU5NjQ0YzIyZTA0MmM2ZWMwNzUyNmVhNGU1NzE1NGY5ZGJjMjA3NmU4YTg0YWMxOTRmMzJcIn0sXCJub25jZVwiOlwiXFxcIjIwMjAtMTAtMTFUMDI6MjE6MTQuMTk0WlxcXCJcIn0ifQ"
    ]

    miner_data =
      "eyJhY2NvdW50IjoiYTFiMzE0MGNiN2NjODk1YzBlMDkxNzAyZWQwNTU3OWZiZTA1YzZlNjc0NWY4MmNlNjAzNzQ2YjQwMGM4MTU0OCIsInByZWRpY2F0ZSI6ImtleXMtYWxsIiwicHVibGljLWtleXMiOlsiYTFiMzE0MGNiN2NjODk1YzBlMDkxNzAyZWQwNTU3OWZiZTA1YzZlNjc0NWY4MmNlNjAzNzQ2YjQwMGM4MTU0OCJdfQ"

    transactions_hash = "lWcQRlj3MV7FSem8P4G-8GMRf1-O7zQqi_AwmWnk-N0"
    outputs_hash = "9BzXZbhjSSevp4K0bYFqi1GdLjeX_DB-4u1T5Em8abs"
    payload_hash = "jcQOWz7K9qKnkUv4Z883D2ZjkFFGgccoSroWGaoogLM"

    %{
      attrs: Chainweb.fixture("block_payload_retrieve_2"),
      outputs_hash: outputs_hash,
      payload_hash: payload_hash,
      transactions: transactions,
      transactions_hash: transactions_hash,
      miner_data: miner_data
    }
  end

  test "new/1", %{
    attrs: attrs,
    outputs_hash: outputs_hash,
    payload_hash: payload_hash,
    transactions: transactions,
    transactions_hash: transactions_hash,
    miner_data: miner_data
  } do
    %BlockPayloadResponse{
      outputs_hash: ^outputs_hash,
      payload_hash: ^payload_hash,
      transactions: ^transactions,
      transactions_hash: ^transactions_hash,
      miner_data: ^miner_data
    } = BlockPayloadResponse.new(attrs)
  end
end
