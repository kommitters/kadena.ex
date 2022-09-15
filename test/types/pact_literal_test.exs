defmodule Kadena.Types.PactLiteralTest do
  @moduledoc """
  `PactLiteral` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactLiteral

  test "new/1 with valid params" do
    %PactLiteral{literal: "string"} = PactLiteral.new("string")
    %PactLiteral{literal: 123} = PactLiteral.new(123)
    %PactLiteral{literal: true} = PactLiteral.new(true)
  end

  test "new/1 with invalid params" do
    {:error, :invalid_literal} = PactLiteral.new(nil)
    {:error, :invalid_literal} = PactLiteral.new([nil])
    {:error, :invalid_literal} = PactLiteral.new(:atom)
    {:error, :invalid_literal} = PactLiteral.new(["string", nil, true])
    {:error, :invalid_literal} = PactLiteral.new([:atom, nil, true])
    {:error, :invalid_literal} = PactLiteral.new([])
  end
end
