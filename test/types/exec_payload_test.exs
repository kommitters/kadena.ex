defmodule Kadena.Types.ExecPayloadTest do
  @moduledoc """
  `ExecPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{ExecPayload, EnvData, PactCode}

  describe "new/1" do
    setup do
      %{
        data: %{},
        code: "(format \"hello {}\" [\"world\"])"
      }
    end

    test "with valid param list", %{data: data, code: code} do
      %ExecPayload{data: %EnvData{data: ^data}, code: %PactCode{code: ^code}} =
        ExecPayload.new(data: data, code: code)
    end

    test "with invalid env data", %{code: code} do
      {:error, [data: :invalid]} = ExecPayload.new(data: "invalid", code: code)
    end

    test "with invalid pact code", %{data: data} do
      {:error, [code: :invalid]} = ExecPayload.new(data: data, code: 12345)
    end
  end
end
