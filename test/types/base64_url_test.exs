defmodule Kadena.Types.Base64UrlTest do
  @moduledoc """
  `Base64Url` struct definition tests
  """

  use ExUnit.Case

  alias Kadena.Types.Base64Url

  setup do
    %{valid_param: "valid_param", invalid_param: :atom}
  end

  test "new/1 with valid params", %{valid_param: valid_param} do
    %Base64Url{value: ^valid_param} = Base64Url.new(valid_param)
  end

  test "new/1 with invalid params", %{invalid_param: invalid_param} do
    {:error, :invalid_string} = Base64Url.new(invalid_param)
  end

  test "new/1 with nil params" do
    {:error, :invalid_string} = Base64Url.new(nil)
  end
end
