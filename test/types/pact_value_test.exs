defmodule Kadena.Types.PactValueTest do
  @moduledoc """
  `PactValue` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactValue

  test "new/1 with valid params" do
    %PactValue{value: "string"} = PactValue.new("string")
    %PactValue{value: 123} = PactValue.new(123)
    %PactValue{value: true} = PactValue.new(true)
    %PactValue{value: ["string", 123, true]} = PactValue.new(["string", 123, true])
  end

  test "new/1 with invalid params" do
    {:error, :invalid_value} = PactValue.new(nil)
    {:error, :invalid_value} = PactValue.new([nil])
    {:error, :invalid_value} = PactValue.new(:atom)
    {:error, :invalid_value} = PactValue.new(["string", nil, true])
    {:error, :invalid_value} = PactValue.new([:atom, nil, true])
    {:error, :invalid_value} = PactValue.new([])
  end
end
