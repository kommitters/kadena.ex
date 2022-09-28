defmodule Kadena.Types.PactValuesListTest do
  @moduledoc """
  `PactValuesList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      %PactValuesList{
        pact_values: [%PactValue{literal: "COIN.transfer"}, %PactValue{literal: 20}]
      } = PactValuesList.new(["COIN.transfer", 20])
    end

    test "with an empty list value" do
      %PactValuesList{pact_values: []} = PactValuesList.new([])
    end

    test "with a nil value" do
      {:error, [pact_values: :not_a_literals_list]} = PactValuesList.new(nil)
    end

    test "with an atom value" do
      {:error, [pact_values: :not_a_literals_list]} = PactValuesList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [pact_values: :invalid]} = PactValuesList.new([nil])
    end

    test "when the list has invalid values" do
      {:error, [pact_values: :invalid]} = PactValuesList.new(["string", 20, :atom, true])
    end
  end
end
