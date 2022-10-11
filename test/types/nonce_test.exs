defmodule Kadena.Types.NonceTest do
  @moduledoc """
  `Nonce` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Nonce

  describe "new/1" do
    test "with a valid value" do
      %Nonce{value: "2022-09-14 21:56:41.642016 UTC"} =
        Nonce.new("2022-09-14 21:56:41.642016 UTC")
    end

    test "with an invalid value" do
      {:error, [value: :invalid]} = Nonce.new(:atom)
    end

    test "with a nil value" do
      {:error, [value: :invalid]} = Nonce.new(nil)
    end
  end
end
