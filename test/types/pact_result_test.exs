defmodule Kadena.Types.PactResultTest do
  @moduledoc """
  `PactResult` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactResult, PactValue}

  describe "new/1" do
    test "with a valid success status" do
      %PactResult{status: :success, result: %PactValue{literal: 3}} =
        PactResult.new(status: :success, result: 3)
    end

    test "with a valid failure status" do
      %PactResult{status: :failure, result: %{}} = PactResult.new(status: :failure, result: %{})
    end

    test "with a valid PactValue result" do
      pact_value = PactValue.new(3)

      %PactResult{status: :success, result: ^pact_value} =
        PactResult.new(status: :success, result: pact_value)
    end

    test "with an invalid status" do
      {:error, [status: :invalid]} = PactResult.new(status: :complete)
    end

    test "with an invalid success result" do
      {:error, [result: :invalid, literal: :invalid]} =
        PactResult.new(status: :success, result: :success)
    end

    test "with an invalid failure result" do
      {:error, [result: :invalid]} = PactResult.new(status: :failure, result: "invalid_error")
    end

    test "with an invalid arguments match" do
      {:error, [result: :invalid]} = PactResult.new(status: :failure, result: 3)
    end
  end
end
