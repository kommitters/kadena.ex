defmodule Kadena.Types.PactLiteralTest do
  @moduledoc """
  `PactLiteral` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactDecimal, PactInt, PactLiteral}

  describe "new/1" do
    test "with a valid string literal" do
      %PactLiteral{literal: "string"} = PactLiteral.new("string")
    end

    test "with a valid number literal" do
      %PactLiteral{literal: 123} = PactLiteral.new(123)
    end

    test "with a valid PactInt literal" do
      pact_int = PactInt.new(123)
      %PactLiteral{literal: ^pact_int} = PactLiteral.new(pact_int)
    end

    test "with a valid PactDecimal literal" do
      pact_decimal = PactDecimal.new("4.634")
      %PactLiteral{literal: ^pact_decimal} = PactLiteral.new(pact_decimal)
    end

    test "with a valid boolean literal" do
      %PactLiteral{literal: true} = PactLiteral.new(true)
    end

    test "with a nil literal" do
      {:error, :invalid_literal} = PactLiteral.new(nil)
    end

    test "with an atom literal" do
      {:error, :invalid_literal} = PactLiteral.new(:atom)
    end

    test "with an empty list literal" do
      {:error, :invalid_literal} = PactLiteral.new([])
    end
  end
end
