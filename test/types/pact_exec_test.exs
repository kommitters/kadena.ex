defmodule Kadena.Types.PactExecTest do
  @moduledoc """
  `PactExec` struct definition tests.
  """

  alias Kadena.Types.{PactExec, PactTransactionHash, Step}

  use ExUnit.Case

  describe "new/1" do
    test "with a valid list params" do
      pact_id = PactTransactionHash.new("wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8")
      step = Step.new(2)

      %PactExec{
        pact_id: ^pact_id,
        step: ^step,
        step_count: 1,
        executed: true,
        step_has_rollback: false
      } =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: 1,
          executed: true,
          step_has_rollback: false
        )
    end

    test "with an invalid pact_id" do
      step = Step.new(2)

      {:error, :invalid_pact_id} =
        PactExec.new(
          pact_id: nil,
          step: step,
          step_count: 1,
          executed: true,
          step_has_rollback: false
        )
    end

    test "with an invalid step" do
      pact_id = PactTransactionHash.new("wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8")

      {:error, :invalid_step} =
        PactExec.new(
          pact_id: pact_id,
          step: nil,
          step_count: 1,
          executed: true,
          step_has_rollback: false
        )
    end

    test "with an invalid step_count" do
      pact_id = PactTransactionHash.new("wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8")
      step = Step.new(2)

      {:error, :invalid_step_count} =
        PactExec.new(
          pact_id: pact_id,
          step: step,
          step_count: "1",
          executed: true,
          step_has_rollback: false
        )
    end

    test "with an invalid empty list" do
      {:error, :invalid_pact_id} = PactExec.new([])
    end
  end
end
