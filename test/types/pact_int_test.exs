defmodule Kadena.Types.PactIntTest do
  @moduledoc """
  `PactInt` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactInt

  describe "new/1" do
    test "With valid params" do
      %PactInt{value: "500"} = PactInt.new("500")
    end

    test "With nil value" do
      {:error, :invalid_int} = PactInt.new(nil)
    end

    test "With atom value" do
      {:error, :invalid_int} = PactInt.new(:atom)
    end

    test "With list of nil" do
      {:error, :invalid_int} = PactInt.new([nil])
    end

    test "With one list item with valid value" do
      {:error, :invalid_int} = PactInt.new(["2333", nil, true])
    end

    test "With each list item with invalid value" do
      {:error, :invalid_int} = PactInt.new([:atom, nil, true])
    end

    test "With empty list value" do
      {:error, :invalid_int} = PactInt.new([])
    end
  end
end
