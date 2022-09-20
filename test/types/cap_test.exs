defmodule Kadena.Types.CapTest do
  @moduledoc """
  `Cap` struct definition tests.
  """

  alias Kadena.Types.{Cap, PactLiteral, PactValue, PactValuesList}

  use ExUnit.Case

  describe "new/1" do
    test "with valid arguments" do
      value = "valid_value" |> PactLiteral.new() |> PactValue.new()
      values_list = PactValuesList.new([value, value, value])

      %Cap{name: "valid_name", args: ^values_list} =
        Cap.new(name: "valid_name", args: values_list)
    end

    test "with an invalid name" do
      value = "valid_value" |> PactLiteral.new() |> PactValue.new()
      values_list = PactValuesList.new([value, value, value])

      {:error, :invalid_cap} = Cap.new(name: 123, args: values_list)
    end

    test "with an invalid values" do
      {:error, :invalid_cap} = Cap.new(name: 123, args: [:atom, nil])
    end

    test "with an empty list values" do
      {:error, :invalid_cap} = Cap.new(name: 123, args: [])
    end
  end
end
