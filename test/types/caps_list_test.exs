defmodule Kadena.Types.CapsListTest do
  @moduledoc """
  `CapsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Cap, CapsList, PactLiteral, PactValue, PactValuesList}

  describe "new/1" do
    test "with a valid list" do
      value = "valid_value" |> PactLiteral.new() |> PactValue.new()
      values_list = PactValuesList.new([value, value, value])
      cap = Cap.new(name: "valid_name", args: values_list)

      caps_list = [cap, cap, cap]
      %CapsList{list: ^caps_list} = CapsList.new(caps_list)
    end

    test "with an empty list value" do
      %CapsList{list: []} = CapsList.new([])
    end

    test "with a nil value" do
      {:error, :invalid_cap} = CapsList.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_cap} = CapsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, :invalid_cap} = CapsList.new([nil])
    end

    test "when the list has invalid values" do
      value = "valid_value" |> PactLiteral.new() |> PactValue.new()
      values_list = PactValuesList.new([value, value, value])
      cap = Cap.new(name: "valid_name", args: values_list)

      invalid_caps_list = [cap, :atom, cap]
      {:error, :invalid_cap} = CapsList.new(invalid_caps_list)
    end
  end
end
