defmodule Kadena.Types.Base64UrlTest do
  @moduledoc """
  `Base64Url` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Base64Url

  test "new/1 with valid url" do
    %Base64Url{url: "valid_url"} = Base64Url.new("valid_url")
  end

  test "new/1 with invalid params" do
    {:error, :invalid_string} = Base64Url.new(:atom)
    {:error, :invalid_string} = Base64Url.new(nil)
  end
end
