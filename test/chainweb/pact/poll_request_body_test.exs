defmodule Kadena.Chainweb.Pact.PollRequestBodyTest do
  @moduledoc """
  `PollRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.{JSONPayload, PollRequestBody}
  alias Kadena.Types.{Base64Url, Base64UrlsList}

  describe "new/1" do
    test "with a valid list" do
      %PollRequestBody{
        request_keys: %Base64UrlsList{
          urls: [
            %Base64Url{url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"},
            %Base64Url{url: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"}
          ]
        }
      } =
        PollRequestBody.new([
          "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"
        ])
    end

    test "with a valid Base64UrlsList struct" do
      list =
        Base64UrlsList.new([
          "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"
        ])

      %PollRequestBody{
        request_keys: ^list
      } = PollRequestBody.new(list)
    end

    test "with an invalid param" do
      {:error, [request_keys: :not_a_list]} = PollRequestBody.new("invalid_param")
    end

    test "with an invalid list" do
      {:error, [request_keys: :invalid]} =
        PollRequestBody.new(["ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q", 123])
    end
  end

  describe "parse/1" do
    setup do
      %{
        json_result: "{\"requestKeys\":[\"jr6N7jQ9nVH0A_gRxe3RfKxR7rHn-IG-GosWz6WnMXQ\"]}"
      }
    end

    test "with a valid PollRequestBody", %{
      json_result: json_result
    } do
      poll = PollRequestBody.new(["jr6N7jQ9nVH0A_gRxe3RfKxR7rHn-IG-GosWz6WnMXQ"])
      ^json_result = JSONPayload.parse(poll)
    end
  end
end
