defmodule Kadena.Types.SignCommandTest do
  @moduledoc """
  `SignCommand` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignatureWithHash, SignCommand, SignedSignatureWithHash}

  describe "new/1" do
    test "with a valid SignatureWithHash" do
      signature =
        SignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig:
            Signature.new(
              "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e"
            ),
          pub_key: "public_key"
        )

      signature_with_hash = SignatureWithHash.new(signature)

      %SignCommand{command: ^signature_with_hash} = SignCommand.new(signature_with_hash)
    end

    test "with a string value" do
      {:error, :invalid_sign_command} = SignCommand.new("signature")
    end

    test "with a nil sig" do
      {:error, :invalid_sign_command} = SignCommand.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_sign_command} = SignCommand.new(:signature)
    end

    test "with a numeric value" do
      {:error, :invalid_sign_command} = SignCommand.new(123)
    end

    test "with an empty list value" do
      {:error, :invalid_sign_command} = SignCommand.new([])
    end
  end
end
