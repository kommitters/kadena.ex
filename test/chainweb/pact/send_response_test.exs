defmodule Kadena.Chainweb.Pact.SendResponseTest do
  @moduledoc """
  `SendResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.SendResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    %{
      attrs: Chainweb.fixture("send")
    }
  end

  test "new/1", %{attrs: attrs} do
    %SendResponse{
      request_keys: [
        "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
        "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM"
      ]
    } = SendResponse.new(attrs)
  end

  test "new/1 empty_attrs" do
    %SendResponse{request_keys: []} = SendResponse.new(%{})
  end
end
