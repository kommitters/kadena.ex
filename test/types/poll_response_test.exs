defmodule Kadena.Types.PollResponseTest do
  @moduledoc """
  `PollResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64UrlsList, PollResponse}

  describe "new/1" do
    setup do
      base64_urls_list = [
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Joaa",
        "zaqnRQ0RYzxTccjtYoBvQsDo5K9mxr4TEF-HIYTi5Jo"
      ]

      %{
        base64_urls_list: base64_urls_list,
        base64_urls_list_struct: Base64UrlsList.new(base64_urls_list)
      }
    end

    test "with valid params", %{
      base64_urls_list: base64_urls_list,
      base64_urls_list_struct: base64_urls_list_struct
    } do
      %PollResponse{request_keys: ^base64_urls_list_struct} = PollResponse.new(base64_urls_list)
    end

    test "with valid base64 urls list struct", %{base64_urls_list_struct: base64_urls_list_struct} do
      %PollResponse{request_keys: ^base64_urls_list_struct} =
        PollResponse.new(base64_urls_list_struct)
    end

    test "with invalid base64 urls list", %{base64_urls_list: base64_urls_list} do
      {:error, [request_keys: :invalid]} = PollResponse.new(base64_urls_list ++ [:invalid])
    end

    test "with invalid list" do
      {:error, [request_keys: :not_a_list]} = PollResponse.new(:invalid)
    end
  end
end
