defmodule Kadena.Types.PollResponseTest do
  @moduledoc """
  `PollResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    Base64Url,
    ChainwebResponseMetaData,
    CommandResult,
    Continuation,
    PactResult,
    PollResponse,
    Yield
  }

  describe "new/1" do
    setup do
      continuation = Continuation.new(def: "coin", args: "pact_value")

      yield =
        Yield.new(
          data: %{
            amount: 0.01,
            receiver: "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc",
            source_chain: 0,
            receiver_guard: [
              pred: "keys-all",
              keys: [
                "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc"
              ]
            ]
          },
          provenance: [
            target_chain_id: "1",
            module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
          ]
        )

      pact_exec_value = [
        pact_id: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
        step: 1,
        step_count: 5,
        executed: false,
        step_has_rollback: false,
        continuation: continuation,
        yield: yield
      ]

      meta_data_value = [
        block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
        block_time: 1_656_709_048_955_370,
        block_height: 2708,
        prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
      ]

      meta_data = ChainwebResponseMetaData.new(meta_data_value)

      result_value = [status: :success, result: 3]
      result = PactResult.new(result_value)

      command_result_params = [
        req_key: "YXNkYXNkYXNkYXNkYXNk",
        tx_id: 123_456,
        result: result,
        gas: 123_456,
        logs: "logs",
        continuation: pact_exec_value,
        meta_data: meta_data,
        events: []
      ]

      command_result = CommandResult.new(command_result_params)

      %{
        key: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs",
        command_result_params: command_result_params,
        command_result: command_result
      }
    end

    test "with valid params", %{
      key: key,
      command_result_params: command_result_params,
      command_result: command_result
    } do
      %PollResponse{key: %Base64Url{url: ^key}, response: ^command_result} =
        PollResponse.new(key: key, response: command_result_params)
    end

    test "with valid commad result struct", %{
      key: key,
      command_result: command_result
    } do
      %PollResponse{key: %Base64Url{url: ^key}, response: ^command_result} =
        PollResponse.new(key: key, response: command_result)
    end

    test "with invalid key", %{command_result: command_result} do
      {:error, [key: :invalid]} = PollResponse.new(key: 123, response: command_result)
    end

    test "with invalid response", %{key: key} do
      {:error, [response: :invalid]} = PollResponse.new(key: key, response: :invalid)
    end

    test "with invalid response list", %{key: key} do
      {:error, [response: :invalid, req_key: :invalid]} =
        PollResponse.new(key: key, response: [:invalid])
    end
  end
end
