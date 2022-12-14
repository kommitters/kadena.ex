defmodule Kadena.Chainweb.Pact.Resources.PactResultTest do
  @moduledoc """
  `PactResult` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Resources.PactResult
  alias Kadena.Types.PactValue

  describe "new/1" do
    test "with a valid success status" do
      %PactResult{status: :success, data: %PactValue{literal: 3}} =
        PactResult.new(%{"status" => "success", "data" => 3})
    end

    test "with a valid failure status" do
      %PactResult{status: :failure, data: %{}} =
        PactResult.new(%{"status" => "failure", "data" => %{}})
    end
  end
end
