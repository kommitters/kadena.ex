defmodule Kadena.Chainweb.Resources.SendResponseTest do
  @moduledoc """
  `SendResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Resources.SendResponse
  alias Kadena.Types.{Base64Url, Base64UrlsList}

  setup do
    %{
      attrs: %{
        "request_keys" => [
          "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"
        ]
      }
    }
  end

  test "new/1", %{attrs: attrs} do
    %SendResponse{
      request_keys: %Base64UrlsList{
        urls: [
          %Base64Url{
            url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"
          },
          %Base64Url{
            url: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"
          }
        ]
      }
    } = SendResponse.new(attrs)
  end

  test "new/1 invalid_request_keys", %{attrs: attrs} do
    attrs = Map.put(attrs, "request_keys", "invalid_request_keys")
    %SendResponse{request_keys: {:error, [urls: :not_a_list]}} = SendResponse.new(attrs)
  end

  test "new/1 empty_attrs" do
    %SendResponse{request_keys: %Base64UrlsList{urls: []}} = SendResponse.new(%{})
  end
end
