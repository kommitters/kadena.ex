defmodule Kadena.Types.ListenRequestBodyTest do
  @moduledoc """
  `ListenRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base64Url, ListenRequestBody}

  describe "new/1" do
    test "with a valid list" do
      %ListenRequestBody{
        listen: %Base64Url{url: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q"}
      } = ListenRequestBody.new("ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q")
    end

    test "with a valid Base64Url struct" do
      listen = Base64Url.new("ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q")

      %ListenRequestBody{listen: ^listen} = ListenRequestBody.new(listen)
    end

    test "with an invalid param" do
      {:error, [listen: :invalid]} = ListenRequestBody.new(123)
    end
  end
end
