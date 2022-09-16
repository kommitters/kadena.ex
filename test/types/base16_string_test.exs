defmodule Kadena.Types.Base16StringTest do
  @moduledoc """
  `Base16String` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Base16String

  describe "new/1" do
    test "With valid params" do
      %Base16String{value: "valid_param"} = Base16String.new("valid_param")
    end

    test "With invalid params" do
      {:error, :invalid_string} = Base16String.new(:atom)
    end

    test "With nil params" do
      {:error, :invalid_string} = Base16String.new(nil)
    end
  end
end
