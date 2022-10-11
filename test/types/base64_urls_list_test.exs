defmodule Kadena.Types.Base64UrlsListTest do
  @moduledoc """
  `Base64UrlsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64Url, Base64UrlsList}

  describe "new/1" do
    test "with a valid urls list" do
      base64_urls_list = [
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa",
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Jo"
      ]

      %Base64UrlsList{
        urls: [
          %Base64Url{url: "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa"},
          %Base64Url{url: "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Jo"}
        ]
      } = Base64UrlsList.new(base64_urls_list)
    end

    test "with an invalid urls list" do
      base64_urls_list = [
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa",
        :atom,
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Jo"
      ]

      {:error, [urls: :invalid, url: :invalid]} = Base64UrlsList.new(base64_urls_list)
    end

    test "with an invalid nil param" do
      {:error, [urls: :not_a_list]} = Base64UrlsList.new(nil)
    end
  end
end
