defmodule Kadena.Chainweb.Pact.ListenRequestBodyTest do
  @moduledoc """
  `ListenRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.{JSONPayload, ListenRequestBody}
  alias Kadena.Types.Base64Url

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

  describe "parse/1" do
    setup do
      %{
        json_result: "{\"listen\":\"y3aWL72-3wAy7vL9wcegGXnstH0lHi-q-cfxkhD5JCw\"}"
      }
    end

    test "with a valid ListenRequestBody", %{
      json_result: json_result
    } do
      listen_request_body = ListenRequestBody.new("y3aWL72-3wAy7vL9wcegGXnstH0lHi-q-cfxkhD5JCw")
      ^json_result = JSONPayload.parse(listen_request_body)
    end
  end
end
