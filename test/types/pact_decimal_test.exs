defmodule Kadena.Types.PactDecimalTest do
  @moduledoc """
  `PactDecimal` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactDecimal

  test "new/1 with valid params" do
    %PactDecimal{value: decimal, raw_value: "4.3333333"} = PactDecimal.new("4.3333333")
    assert Decimal.equal?(decimal, Decimal.new("4.3333333"))
  end

  test "new/1 with invalid params" do
    {:error, :invalid_decimal} = PactDecimal.new(nil)
    {:error, :invalid_decimal} = PactDecimal.new([nil])
    {:error, :invalid_decimal} = PactDecimal.new(:atom)
    {:error, :invalid_decimal} = PactDecimal.new(["string", nil, true])
    {:error, :invalid_decimal} = PactDecimal.new([:atom, nil, true])
    {:error, :invalid_decimal} = PactDecimal.new([])
  end
end
