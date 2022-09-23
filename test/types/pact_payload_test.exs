defmodule Kadena.Types.PactPayloadTest do
  @moduledoc """
  `pactPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{ContPayload, ExecPayload, PactPayload}

  describe "new/1" do
    setup do
      data = %{},
      code = "(format \"hello {}\" [\"world\"])"
      pact_id = "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
      step = 2,
      proof = "valid_proof",
      rollback = true

      %{
        exec: ContPayload.new(data: data, pact_id: pact_id, step: step, proof: proof, rollback: rollback),
        cont: ExecPayload.new(data: data, code: code)
      }
    end

    test "with valid exec payload", %{exec: exec} do
      %ExecPayload{payload: ^exec} = PactPayload.new(exec)
    end

    test "with valid cont payload", %{cont: cont} do
      %ExecPayload{payload: ^cont} = PactPayload.new(cont)
    end

    test "with invalid exec payload" do
      {:error, :invalid_payload} = PactPayload.new("invalid_exec")
    end
  end
end
