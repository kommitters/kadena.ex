defmodule Kadena.Types.PactIntTest do
  @moduledoc """
  `PactInt` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactInt

  describe "new/1" do
    test "with a valid integer" do
      %PactInt{value: 500, raw_value: "500"} = PactInt.new(500)
    end

    test "with a nil value" do
      {:error, :invalid_int} = PactInt.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_int} = PactInt.new(:atom)
    end

    test "with an empty list" do
      {:error, :invalid_int} = PactInt.new([])
    end
  end
end
