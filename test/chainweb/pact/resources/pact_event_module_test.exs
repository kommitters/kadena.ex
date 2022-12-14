defmodule Kadena.Chainweb.Pact.Resources.PactEventModuleTest do
  @moduledoc """
  `PactEventModule` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Resources.PactEventModule

  setup do
    %{
      attrs: %{
        "name" => "coin",
        "namespace" => "free"
      }
    }
  end

  test "new/1", %{attrs: attrs} do
    %PactEventModule{name: "coin", namespace: "free"} = PactEventModule.new(attrs)
  end

  test "new/1 with nil namespace", %{attrs: attrs} do
    attrs = Map.put(attrs, "namespace", nil)

    %PactEventModule{name: "coin", namespace: nil} = PactEventModule.new(attrs)
  end
end
