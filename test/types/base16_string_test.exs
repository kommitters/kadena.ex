defmodule Kadena.Types.Base16StringTest do
  @moduledoc """
  `Base16String` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Base16String

  describe "new/1" do
    test "with a valid string value" do
      %Base16String{value: "string"} = Base16String.new("string")
    end

    test "with an invalid atom value" do
      {:error, :invalid_string} = Base16String.new(:atom)
    end

    test "with an invalid nil value" do
      {:error, :invalid_string} = Base16String.new(nil)
    end
  end
end
