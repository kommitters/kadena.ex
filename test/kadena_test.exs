defmodule KadenaTest do
  use ExUnit.Case
  doctest Kadena

  test "greets the world" do
    assert Kadena.hello() == :world
  end
end
