defmodule Kadena.Types.PactValuesListTest do
  @moduledoc """
  `PactValuesList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactLiteral, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      literal_string = PactLiteral.new("string")
      value = PactValue.new(literal_string)

      values_list = [value, value, value, value]
      %PactValuesList{list: ^values_list} = PactValuesList.new(values_list)
    end

    test "with an empty list value" do
      %PactValuesList{list: []} = PactValuesList.new([])
    end

    test "with a nil value" do
      {:error, :invalid_value} = PactValuesList.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_value} = PactValuesList.new(:atom)
    end

    test "with a list of nil" do
      {:error, :invalid_value} = PactValuesList.new([nil])
    end

    test "when the list has invalid values" do
      valid_value = true |> PactLiteral.new() |> PactValue.new()
      invalid_values_list = [valid_value, :atom]
      {:error, :invalid_value} = PactValuesList.new(invalid_values_list)
    end
  end
end
