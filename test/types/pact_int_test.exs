defmodule Kadena.Types.PactIntTest do
  @moduledoc """
  `PactInt` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactInt

  test "new/1 with valid params" do
    %PactInt{value: "500"} = PactInt.new("500")
  end

  test "new/1 with invalid params" do
    {:error, :invalid_int} = PactInt.new(nil)
    {:error, :invalid_int} = PactInt.new([nil])
    {:error, :invalid_int} = PactInt.new(:atom)
    {:error, :invalid_int} = PactInt.new(["string", nil, true])
    {:error, :invalid_int} = PactInt.new([:atom, nil, true])
    {:error, :invalid_int} = PactInt.new([])
  end
end
