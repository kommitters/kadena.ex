defmodule Kadena.Types.ContPayloadTest do
  @moduledoc """
  `ContPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{ContPayload, EnvData, PactTransactionHash, Proof, Rollback, Step}

  describe "new/1" do
    setup do
      %{
        data: %{},
        pact_id: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
        step: 2,
        proof: "valid_proof",
        rollback: true
      }
    end

    test "with valid param list", %{
      data: data,
      pact_id: pact_id,
      step: step,
      proof: proof,
      rollback: rollback
    } do
      %ContPayload{
        data: %EnvData{data: ^data},
        pact_id: %PactTransactionHash{url: ^pact_id},
        step: %Step{number: ^step},
        proof: %Proof{url: ^proof},
        rollback: %Rollback{value: ^rollback}
      } =
        ContPayload.new(
          data: data,
          pact_id: pact_id,
          step: step,
          proof: proof,
          rollback: rollback
        )
    end

    test "with invalid data", %{pact_id: pact_id, step: step, proof: proof, rollback: rollback} do
      {:error, [data: :invalid]} =
        ContPayload.new(
          data: "{}",
          pact_id: pact_id,
          step: step,
          proof: proof,
          rollback: rollback
        )
    end

    test "with invalid pact id", %{data: data, step: step, proof: proof, rollback: rollback} do
      {:error, [pact_id: :invalid]} =
        ContPayload.new(
          data: data,
          pact_id: 12345,
          step: step,
          proof: proof,
          rollback: rollback
        )
    end

    test "with invalid step", %{data: data, pact_id: pact_id, proof: proof, rollback: rollback} do
      {:error, [step: :invalid]} =
        ContPayload.new(data: data, pact_id: pact_id, step: "5", proof: proof, rollback: rollback)
    end

    test "with invalid proof", %{data: data, pact_id: pact_id, step: step, rollback: rollback} do
      {:error, [proof: :invalid]} =
        ContPayload.new(
          data: data,
          pact_id: pact_id,
          step: step,
          proof: 12345,
          rollback: rollback
        )
    end

    test "with invalid rollback", %{data: data, pact_id: pact_id, step: step, proof: proof} do
      {:error, [rollback: :invalid]} =
        ContPayload.new(data: data, pact_id: pact_id, step: step, proof: proof, rollback: "false")
    end
  end
end
