defmodule Kadena.Types.Uint8ArrayTest do
  @moduledoc """
  `Uint8Array` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Uint8Array

  describe "new/1" do
    test "with a valid buffer" do
      %Uint8Array{value: [254, 255, 0, 1, 2]} = Uint8Array.new(<<254, 255, 256, 257, 258>>)
    end

    test "with a valid list" do
      values_list = [134, 147, 230, 65, 174, 43, 190, 158]
      %Uint8Array{value: ^values_list} = Uint8Array.new(values_list)
    end

    test "with a negative value in the list" do
      {:error, :invalid_uint8_array} = Uint8Array.new([230, -65, 174])
    end

    test "with an invalid input" do
      {:error, :invalid_uint8_array} = Uint8Array.new(-5)
    end

    test "with a nil value" do
      {:error, :invalid_uint8_array} = Uint8Array.new(nil)
    end

    test "with an invalid list" do
      values_list = [134, 147, 230, 65, 174, 43, 190, :atom, 158]
      {:error, :invalid_uint8_array} = Uint8Array.new(values_list)
    end
  end
end
