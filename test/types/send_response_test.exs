defmodule Kadena.Types.SendResponseTest do
  @moduledoc """
  `SendResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64Url, Base64UrlsList, SendResponse}

  describe "new/1" do
    test "with a valid list" do
      %SendResponse{
        request_keys: %Base64UrlsList{
          urls: [
            %Base64Url{url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"},
            %Base64Url{url: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"}
          ]
        }
      } =
        SendResponse.new([
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

      %SendResponse{
        request_keys: ^list
      } = SendResponse.new(list)
    end

    test "with an invalid param" do
      {:error, [request_keys: :not_a_list]} = SendResponse.new("invalid_param")
    end

    test "with an invalid list" do
      {:error, [request_keys: :invalid]} =
        SendResponse.new(["ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q", 123])
    end
  end
end
