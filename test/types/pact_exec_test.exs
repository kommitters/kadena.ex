defmodule Kadena.Types.PactExecTest do
  @moduledoc """
  `PactExec` struct definition tests.
  """
  use ExUnit.Case

  alias Kadena.Types.{Continuation, PactExec, PactTransactionHash, Step, Yield}

  describe "new/1" do
    setup do
      continuation_value = [def: "coin", args: "pact_value"]

      yield_value = [
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
      ]

      %{
        pact_id: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
        step: 1,
        step_count: 5,
        bool_value: false,
        continuation: continuation_value,
        continuation_struct: Continuation.new(continuation_value),
        yield: yield_value,
        yield_struct: Yield.new(yield_value)
      }
    end

    test "with a valid args list", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation,
      continuation_struct: continuation_struct,
      yield: yield,
      yield_struct: yield_struct
    } do
      %PactExec{
        pact_id: %PactTransactionHash{hash: ^pact_id},
        step: %Step{number: ^step},
        step_count: ^step_count,
        executed: ^bool_value,
        step_has_rollback: ^bool_value,
        continuation: ^continuation_struct,
        yield: ^yield_struct
      } =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          executed: bool_value,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: yield
        )
    end

    test "with a valid nil executed value", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation,
      continuation_struct: continuation_struct,
      yield: yield,
      yield_struct: yield_struct
    } do
      %PactExec{
        pact_id: %PactTransactionHash{hash: ^pact_id},
        step: %Step{number: ^step},
        step_count: ^step_count,
        executed: nil,
        step_has_rollback: ^bool_value,
        continuation: ^continuation_struct,
        yield: ^yield_struct
      } =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: yield
        )
    end

    test "with a valid nil yield", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation,
      continuation_struct: continuation_struct
    } do
      %PactExec{
        pact_id: %PactTransactionHash{hash: ^pact_id},
        step: %Step{number: ^step},
        step_count: ^step_count,
        step_has_rollback: ^bool_value,
        continuation: ^continuation_struct,
        yield: nil
      } =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation
        )
    end

    test "with a valid yield and continuation structs", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation_struct: continuation_struct,
      yield_struct: yield_struct
    } do
      %PactExec{
        pact_id: %PactTransactionHash{hash: ^pact_id},
        step: %Step{number: ^step},
        step_count: ^step_count,
        step_has_rollback: ^bool_value,
        continuation: ^continuation_struct,
        yield: ^yield_struct
      } =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation_struct,
          yield: yield_struct
        )
    end

    test "with an invalid pact_id", %{
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation,
      yield: yield
    } do
      {:error, [pact_id: :invalid]} =
        PactExec.new(
          pact_id: :invalid_pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: yield
        )
    end

    test "with an invalid step", %{
      pact_id: pact_id,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation,
      yield: yield
    } do
      {:error, [step: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: "step1",
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: yield
        )
    end

    test "with an invalid step_count", %{
      pact_id: pact_id,
      step: step,
      bool_value: bool_value,
      continuation: continuation,
      yield: yield
    } do
      {:error, [step_count: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: "step_count",
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: yield
        )
    end

    test "with an invalid step_has_rollback", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      continuation: continuation,
      yield: yield
    } do
      {:error, [step_has_rollback: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: "none",
          continuation: continuation,
          yield: yield
        )
    end

    test "with an invalid continuation", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      yield: yield
    } do
      {:error, [continuation: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: :invalid,
          yield: yield
        )
    end

    test "with an invalid continuation list", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      yield: yield
    } do
      {:error, [continuation: :invalid, def: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: [invalid_arg: :invalid_value],
          yield: yield
        )
    end

    test "with an invalid yield", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation
    } do
      {:error, [yield: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: :yield
        )
    end

    test "with an invalid yield args list", %{
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      bool_value: bool_value,
      continuation: continuation
    } do
      {:error, [yield: :invalid, data: :invalid]} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: step_count,
          step_has_rollback: bool_value,
          continuation: continuation,
          yield: [:yield]
        )
    end

    test "with an invalid empty list" do
      {:error, [pact_id: :invalid]} = PactExec.new([])
    end
  end
end
