defmodule Kadena.Types.PactLiteralsListTest do
  @moduledoc """
  `PactLiteralsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactDecimal, PactInt, PactLiteral, PactLiteralsList}

  describe "new/1" do
    test "with a valid list" do
      literal_string = PactLiteral.new("string")
      literal_int = 123 |> PactInt.new() |> PactLiteral.new()
      literal_decimal = "2.3333" |> PactDecimal.new() |> PactLiteral.new()
      literal_boolean = PactLiteral.new(true)

      literals_list = [literal_string, literal_int, literal_decimal, literal_boolean]
      reversed_literals_list = [literal_boolean, literal_decimal, literal_int, literal_string]
      %PactLiteralsList{list: ^reversed_literals_list} = PactLiteralsList.new(literals_list)
    end

    test "with an empty list value" do
      %PactLiteralsList{list: []} = PactLiteralsList.new([])
    end

    test "with a nil value" do
      {:error, :invalid_literal} = PactLiteralsList.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_literal} = PactLiteralsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, :invalid_literal} = PactLiteralsList.new([nil])
    end

    test "when the list has invalid values" do
      invalid_literals_list = [PactLiteral.new(true), :atom]
      {:error, :invalid_literal} = PactLiteralsList.new(invalid_literals_list)
    end
  end
end
