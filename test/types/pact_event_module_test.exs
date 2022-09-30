defmodule Kadena.Types.PactEventModuleTest do
  @moduledoc """
  `PactEventModule` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactEventModule

  describe "new/1" do
    test "with valid arguments" do
      %PactEventModule{name: "coin", name_space: "free"} =
        PactEventModule.new(name: "coin", name_space: "free")
    end

    test "with a valid nil name_space" do
      %PactEventModule{name: "coin", name_space: nil} = PactEventModule.new(name: "coin")
    end

    test "with an invalid nil name" do
      {:error, [name: :invalid]} = PactEventModule.new(name: nil, name_space: nil)
    end

    test "with an invalid name_space" do
      {:error, [name_space: :invalid]} = PactEventModule.new(name: "coin", name_space: :name)
    end
  end
end
