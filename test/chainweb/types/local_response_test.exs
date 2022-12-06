defmodule Kadena.Chainweb.Types.LocalResponseTest do
  @moduledoc """
  `LocalResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    Base64Url,
    ChainwebResponseMetaData,
    Continuation,
    LocalResponse,
    OptionalPactEventsList,
    PactEventsList,
    PactExec,
    PactResult,
    Yield
  }

  alias Kadena.Chainweb.Types.LocalResponse

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

      pact_exec = PactExec.new(pact_exec_value)

      meta_data_value = [
        block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
        block_time: 1_656_709_048_955_370,
        block_height: 2708,
        prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
      ]

      meta_data = ChainwebResponseMetaData.new(meta_data_value)

      result_value = [status: :success, result: 3]
      result = PactResult.new(result_value)
      pact_events_list = PactEventsList.new([])

      %{
        req_key: "YXNkYXNkYXNkYXNkYXNk",
        tx_id: 123_456,
        result_value: result_value,
        result: result,
        gas: 123_456,
        logs: "logs",
        continuation_value: pact_exec_value,
        continuation: pact_exec,
        meta_data_value: meta_data_value,
        meta_data: meta_data,
        events_value: [],
        events: pact_events_list
      }
    end

    test "with valid params", %{
      req_key: req_key,
      tx_id: tx_id,
      result_value: result_value,
      result: result,
      gas: gas,
      logs: logs,
      continuation_value: continuation_value,
      continuation: continuation,
      meta_data_value: meta_data_value,
      meta_data: meta_data,
      events_value: events_value,
      events: events
    } do
      %LocalResponse{
        req_key: %Base64Url{url: ^req_key},
        tx_id: ^tx_id,
        result: ^result,
        gas: ^gas,
        logs: ^logs,
        continuation: ^continuation,
        meta_data: ^meta_data,
        events: %OptionalPactEventsList{pact_events: ^events}
      } =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result_value,
          gas: gas,
          logs: logs,
          continuation: continuation_value,
          meta_data: meta_data_value,
          events: events_value
        )
    end

    test "with valid struct params", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      %LocalResponse{
        req_key: %Base64Url{url: ^req_key},
        tx_id: ^tx_id,
        result: ^result,
        gas: ^gas,
        logs: ^logs,
        continuation: ^continuation,
        meta_data: ^meta_data,
        events: %OptionalPactEventsList{pact_events: ^events}
      } =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with valid nil tx_id, logs, meta_data and events", %{
      req_key: req_key,
      result: result,
      gas: gas,
      continuation: continuation
    } do
      %LocalResponse{
        req_key: %Base64Url{url: ^req_key},
        tx_id: nil,
        result: ^result,
        gas: ^gas,
        logs: nil,
        continuation: ^continuation,
        meta_data: nil,
        events: %OptionalPactEventsList{pact_events: nil}
      } =
        LocalResponse.new(
          req_key: req_key,
          tx_id: nil,
          result: result,
          gas: gas,
          logs: nil,
          continuation: continuation,
          meta_data: nil,
          events: nil
        )
    end

    test "with invalid req_key", %{
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [req_key: :invalid]} =
        LocalResponse.new(
          req_key: :invalid,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid tx_id", %{
      req_key: req_key,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [tx_id: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: "invalid",
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid result", %{
      req_key: req_key,
      tx_id: tx_id,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [result: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: "invalid",
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid result list", %{
      req_key: req_key,
      tx_id: tx_id,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [result: :invalid, status: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: [status: :invalid_status, result: 3],
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid gas", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [gas: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: "invalid",
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid logs", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      continuation: continuation,
      meta_data: meta_data,
      events: events
    } do
      {:error, [logs: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: :invalid,
          continuation: continuation,
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid continuation", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      meta_data: meta_data,
      events: events
    } do
      {:error, [continuation: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: "invalid",
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid continuation list", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      meta_data: meta_data,
      events: events
    } do
      {:error, [continuation: :invalid, pact_id: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: [invalid_key: :invalid_value],
          meta_data: meta_data,
          events: events
        )
    end

    test "with invalid meta_data", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      events: events
    } do
      {:error, [meta_data: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: "invalid",
          events: events
        )
    end

    test "with invalid meta_data list", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      events: events
    } do
      {:error, [meta_data: :invalid, block_hash: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: ["invalid"],
          events: events
        )
    end

    test "with invalid events", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data
    } do
      {:error, [events: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: "invalid"
        )
    end

    test "with invalid events list", %{
      req_key: req_key,
      tx_id: tx_id,
      result: result,
      gas: gas,
      logs: logs,
      continuation: continuation,
      meta_data: meta_data
    } do
      {:error, [events: :invalid, pact_events: :invalid, name: :invalid]} =
        LocalResponse.new(
          req_key: req_key,
          tx_id: tx_id,
          result: result,
          gas: gas,
          logs: logs,
          continuation: continuation,
          meta_data: meta_data,
          events: [[name: :invalid_value]]
        )
    end
  end
end
