defmodule Kadena.Types.SignatureTest do
  @moduledoc """
  `Signature` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Signature

  describe "new/1" do
    test "with a valid sig" do
      %Signature{
        sig:
          "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e"
      } =
        Signature.new(
          "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e"
        )
    end

    test "with a nil sig" do
      {:error, [sig: :invalid]} = Signature.new(nil)
    end

    test "with an atom value" do
      {:error, [sig: :invalid]} = Signature.new(:signature)
    end

    test "with a numeric value" do
      {:error, [sig: :invalid]} = Signature.new(123)
    end

    test "with an empty list value" do
      {:error, [sig: :invalid]} = Signature.new([])
    end
  end
end
