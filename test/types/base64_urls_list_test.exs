defmodule Kadena.Types.Base64UrlsListTest do
  @moduledoc """
  `Base64UrlsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64Url, Base64UrlsList}

  describe "new/1" do
    test "with a valid urls list" do
      base_url = Base64Url.new("valid_url")
      %Base64UrlsList{list: [base_url, base_url]} = Base64UrlsList.new([base_url, base_url])
    end

    test "with an invalid urls list" do
      base_url = Base64Url.new("valid_url")
      {:error, :invalid_urls} = Base64UrlsList.new([base_url, :atom, base_url])
    end

    test "with a list of nil" do
      {:error, :invalid_urls} = Base64UrlsList.new([nil])
    end
  end
end
