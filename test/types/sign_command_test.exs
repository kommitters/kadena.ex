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
          hash: "valid_hash",
          sig: Signature.new("valid signature"),
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
