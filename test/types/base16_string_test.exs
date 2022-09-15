defmodule Kadena.Types.Base16StringTest do
  @moduledoc """
  `Base16String` struct definition tests
  """

  use ExUnit.Case

  alias Kadena.Types.Base16String

  setup do
    %{valid_param: "valid_param", invalid_param: :atom}
  end

  test "new/1 with valid params", %{valid_param: valid_param} do
    %Base16String{value: ^valid_param} = Base16String.new(valid_param)
  end

  test "new/1 with invalid params", %{invalid_param: invalid_param} do
    {:error, :invalid_string} = Base16String.new(invalid_param)
  end

  test "new/1 with nil params" do
    {:error, :invalid_string} = Base16String.new(nil)
  end
end
