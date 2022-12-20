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
        "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc",
        "gyShUgtFBk5xDoiBoLURbU_5vUG0benKroNDRhz8wqA"
      ]
    } = SendResponse.new(attrs)
  end

  test "new/1 empty_attrs" do
    %SendResponse{request_keys: []} = SendResponse.new(%{})
  end
end
