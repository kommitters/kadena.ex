defmodule Kadena.Types.ContinuationTest do
  @moduledoc """
  `Continuation` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Continuation, PactValue}

  describe "new/1" do
    test "with valid arguments" do
      %Continuation{def: "def", args: %PactValue{literal: "pact_value"}} =
        Continuation.new(def: "def", args: "pact_value")
    end

    test "with valid pact value" do
      pact_value = PactValue.new("pact_value")

      %Continuation{def: "def", args: ^pact_value} =
        Continuation.new(def: "def", args: pact_value)
    end

    test "with invalid def" do
      {:error, [def: :invalid]} = Continuation.new(def: :invalid, args: "pact_value")
    end

    test "with invalid args" do
      {:error, [args: :invalid]} = Continuation.new(def: "def", args: %{})
    end
  end
end
