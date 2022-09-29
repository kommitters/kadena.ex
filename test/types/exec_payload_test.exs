defmodule Kadena.Types.ExecPayloadTest do
  @moduledoc """
  `ExecPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{EnvData, ExecPayload, PactCode}

  describe "new/1" do
    setup do
      %{
        data: %{},
        code: "(format \"hello {}\" [\"world\"])"
      }
    end

    test "with a valid param list", %{data: data, code: code} do
      %ExecPayload{data: %EnvData{data: ^data}, code: %PactCode{code: ^code}} =
        ExecPayload.new(data: data, code: code)
    end

    test "with a nil data", %{code: code} do
      %ExecPayload{data: nil, code: %PactCode{code: ^code}} =
        ExecPayload.new(data: nil, code: code)
    end

    test "with an invalid env data", %{code: code} do
      {:error, [data: :invalid]} = ExecPayload.new(data: "invalid", code: code)
    end

    test "with an invalid pact code", %{data: data} do
      {:error, [code: :invalid]} = ExecPayload.new(data: data, code: 12_345)
    end
  end
end
