defmodule Kadena.Types.PactResultSuccessTest do
  @moduledoc """
  `PactResultSuccess` struct definition tests.
  """

  alias Kadena.Types.{PactLiteral, PactResultSuccess, PactValue}

  use ExUnit.Case

  describe "new/1" do
    test "with a valid pact value" do
      value = 3 |> PactLiteral.new() |> PactValue.new()
      %PactResultSuccess{status: :success, data: ^value} = PactResultSuccess.new(value)
    end
    test "with an invalid value" do
      {:error, :invalid_pact_result} = PactResultSuccess.new(:2)
    end
    test "with an invalid value" do
      {:error, :invalid_pact_result} = PactResultSuccess.new(nil)
    end
  end
end
