defmodule Kadena.Types.Base64UrlTest do
  @moduledoc """
  `Base64Url` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Base64Url

  describe "new/1" do
    test "With valid url" do
      %Base64Url{url: "valid_url"} = Base64Url.new("valid_url")
    end

    test "With invalid url" do
      {:error, :invalid_string} = Base64Url.new(:atom)
    end

    test "With nil url" do
      {:error, :invalid_string} = Base64Url.new(nil)
    end
  end
end
