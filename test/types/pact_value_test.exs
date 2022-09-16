defmodule Kadena.Types.PactValueTest do
  @moduledoc """
  `PactValue` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactValue

  describe "new/1" do
    test "With valid string" do
      %PactValue{value: "string"} = PactValue.new("string")
    end

    test "With valid number" do
      %PactValue{value: 123} = PactValue.new(123)
    end

    test "With valid boolean" do
      %PactValue{value: true} = PactValue.new(true)
    end

    test "With each list item with valid value" do
      %PactValue{value: ["string", 123, true]} = PactValue.new(["string", 123, true])
    end

    test "With nil value" do
      {:error, :invalid_value} = PactValue.new(nil)
    end

    test "With atom value" do
      {:error, :invalid_value} = PactValue.new(:atom)
    end

    test "With list of nil" do
      {:error, :invalid_value} = PactValue.new([nil])
    end

    test "With one list item with invalid value" do
      {:error, :invalid_value} = PactValue.new(["string", nil, true])
    end

    test "With each list item with invalid value" do
      {:error, :invalid_value} = PactValue.new([:atom, nil, true])
    end

    test "With empty list value" do
      {:error, :invalid_value} = PactValue.new([])
    end
  end
end
