defmodule Kadena.Types.PactLiteralTest do
  @moduledoc """
  `PactLiteral` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactLiteral

  describe "new/1" do
    test "With valid string" do
      %PactLiteral{literal: "string"} = PactLiteral.new("string")
    end

    test "With valid number" do
      %PactLiteral{literal: 123} = PactLiteral.new(123)
    end

    test "With valid boolean" do
      %PactLiteral{literal: true} = PactLiteral.new(true)
    end

    test "With nil value" do
      {:error, :invalid_literal} = PactLiteral.new(nil)
    end

    test "With atom value" do
      {:error, :invalid_literal} = PactLiteral.new(:atom)
    end

    test "With list of nil" do
      {:error, :invalid_literal} = PactLiteral.new([nil])
    end

    test "With one list item with invalid value" do
      {:error, :invalid_literal} = PactLiteral.new(["string", nil, true])
    end

    test "With each list item with valid value" do
      {:error, :invalid_literal} = PactLiteral.new(["string", 123, true])
    end

    test "With each list item with invalid value" do
      {:error, :invalid_literal} = PactLiteral.new([:atom, nil, true])
    end

    test "With empty list value" do
      {:error, :invalid_literal} = PactLiteral.new([])
    end
  end
end
