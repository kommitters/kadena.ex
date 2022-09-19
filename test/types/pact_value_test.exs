defmodule Kadena.Types.PactValueTest do
  @moduledoc """
  `PactValue` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactDecimal, PactInt, PactLiteral, PactLiteralsList, PactValue}

  describe "new/1" do
    setup do
      literal_string = PactLiteral.new("string")
      literal_int = 123 |> PactInt.new() |> PactLiteral.new()
      literal_decimal = "2.3333" |> PactDecimal.new() |> PactLiteral.new()
      literal_boolean = PactLiteral.new(true)

      literal_list =
        PactLiteralsList.new([literal_string, literal_int, literal_decimal, literal_boolean])

      %{
        literal_string: literal_string,
        literal_int: literal_int,
        literal_decimal: literal_decimal,
        literal_boolean: literal_boolean,
        literal_list: literal_list
      }
    end

    test "with a valid string", %{literal_string: literal_string} do
      %PactValue{value: ^literal_string} = PactValue.new(literal_string)
    end

    test "with a valid PactInt", %{literal_int: literal_int} do
      %PactValue{value: ^literal_int} = PactValue.new(literal_int)
    end

    test "with a valid PactDecimal", %{literal_decimal: literal_decimal} do
      %PactValue{value: ^literal_decimal} = PactValue.new(literal_decimal)
    end

    test "with a valid boolean", %{literal_boolean: literal_boolean} do
      %PactValue{value: ^literal_boolean} = PactValue.new(literal_boolean)
    end

    test "with a valid PactLiteralList", %{literal_list: literal_list} do
      %PactValue{value: ^literal_list} = PactValue.new(literal_list)
    end

    test "with an invalid list" do
      {:error, :invalid_value} =
        ["string", :atom, true] |> PactLiteralsList.new() |> PactValue.new()
    end

    test "with a nil value" do
      {:error, :invalid_value} = PactValue.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_value} = PactValue.new(:atom)
    end

    test "with a list of nil" do
      {:error, :invalid_value} = PactValue.new([nil])
    end

    test "with empty list value" do
      {:error, :invalid_value} = PactValue.new([])
    end
  end
end
