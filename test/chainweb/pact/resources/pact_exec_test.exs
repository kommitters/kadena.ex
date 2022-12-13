defmodule Kadena.Chainweb.Pact.Resources.PactExecTest do
  @moduledoc """
  `PactExec` struct definition tests.
  """
  use ExUnit.Case

  alias Kadena.Types.{ChainID, PactTransactionHash, PactValue, Step}
  alias Kadena.Chainweb.Pact.Resources.{Continuation, PactExec, Provenance, Yield}

  setup do
    attrs = %{
      "continuation" => %{"args" => "pact_value", "def" => "coin"},
      "executed" => false,
      "pact_id" => "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
      "step" => 1,
      "step_count" => 5,
      "step_has_rollback" => false,
      "yield" => %{
        "data" => %{
          "amount" => 0.01,
          "receiver" => "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc",
          "receiver_guard" => %{
            "keys" => ["4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc"],
            "pred" => "keys-all"
          },
          "source_chain" => 0
        },
        "provenance" => %{
          "module_hash" => "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
          "target_chain_id" => "1"
        }
      }
    }

    continuation = %Continuation{
      args: %PactValue{literal: "pact_value"},
      def: "coin"
    }

    executed = false
    pact_id = %PactTransactionHash{hash: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"}
    step = %Step{number: 1}
    step_count = 5
    step_has_rollback = false

    yield = %Yield{
      data: %{
        "amount" => 0.01,
        "receiver" => "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc",
        "receiver_guard" => %{
          "keys" => ["4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc"],
          "pred" => "keys-all"
        },
        "source_chain" => 0
      },
      provenance: %Provenance{
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
        target_chain_id: %ChainID{id: "1"}
      }
    }

    %{
      attrs: attrs,
      continuation: continuation,
      executed: executed,
      pact_id: pact_id,
      step: step,
      step_count: step_count,
      step_has_rollback: step_has_rollback,
      yield: yield
    }
  end

  test "new/1", %{
    attrs: attrs,
    continuation: continuation,
    executed: executed,
    pact_id: pact_id,
    step: step,
    step_count: step_count,
    step_has_rollback: step_has_rollback,
    yield: yield
  } do
    %PactExec{
      continuation: ^continuation,
      executed: ^executed,
      pact_id: ^pact_id,
      step: ^step,
      step_count: ^step_count,
      step_has_rollback: ^step_has_rollback,
      yield: ^yield
    } = PactExec.new(attrs)
  end

  test "new/1 with nil executed and yield", %{
    attrs: attrs,
    continuation: continuation,
    pact_id: pact_id,
    step: step,
    step_count: step_count,
    step_has_rollback: step_has_rollback
  } do
    attrs = Map.put(attrs, "executed", nil)
    attrs = Map.put(attrs, "yield", nil)

    %PactExec{
      continuation: ^continuation,
      executed: nil,
      pact_id: ^pact_id,
      step: ^step,
      step_count: ^step_count,
      step_has_rollback: ^step_has_rollback,
      yield: nil
    } = PactExec.new(attrs)
  end
end
