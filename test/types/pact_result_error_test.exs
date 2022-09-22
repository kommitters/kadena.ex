defmodule Kadena.Types.PactResultErrorTest do
  @moduledoc """
  `PactResultError` struct definition tests.
  """

  alias Kadena.Types.PactResultError

  use ExUnit.Case

  describe "new/1" do
    test "with a valid map" do
      error = %{
        callStack: [],
        type: "GasError",
        message: "Tx too big (28), limit 0",
        info: ""
      }

      %PactResultError{status: :failure, error: ^error} = PactResultError.new(error)
    end

    test "with a empty map" do
      %PactResultError{status: :failure, error: %{}} = PactResultError.new(%{})
    end

    test "with a empty list" do
      {:error, :invalid_pact_result} = PactResultError.new([])
    end

    test "with a nil input" do
      {:error, :invalid_pact_result} = PactResultError.new(nil)
    end
  end
end
