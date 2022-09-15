defmodule Kadena.Types.Base16StringTest do
  @moduledoc """
  `Base16String` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Base16String

  test "new/1 with valid params" do
    %Base16String{value: "valid_param"} = Base16String.new("valid_param")
  end

  test "new/1 with invalid params" do
    {:error, :invalid_string} = Base16String.new(:atom)
    {:error, :invalid_string} = Base16String.new(nil)
  end
end
