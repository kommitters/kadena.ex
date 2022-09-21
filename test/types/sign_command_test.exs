defmodule Kadena.Types.SignCommandTest do
  @moduledoc """
  `SignCommand` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    Signature,
    SignatureWithHash,
    SignCommand,
    SignedSignatureWithHash,
    UnsignedSignatureWithHash
  }

  describe "new/1" do
    setup do
      %{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sig:
          Signature.new(
            "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e"
          ),
        pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
      }
    end

    test "with a valid SignatureWithHash", %{hash: hash, sig: sig, pub_key: pub_key} do
      signature = SignedSignatureWithHash.new(hash: hash, sig: sig, pub_key: pub_key)

      signature_with_hash = SignatureWithHash.new(signature)

      %SignCommand{command: ^signature_with_hash} = SignCommand.new(signature_with_hash)
    end

    test "with a valid UnsignatureWithHash", %{hash: hash, sig: sig} do
      signature = UnsignedSignatureWithHash.new(hash: hash, sig: sig)

      signature_with_hash = SignatureWithHash.new(signature)

      %SignCommand{command: ^signature_with_hash} = SignCommand.new(signature_with_hash)
    end

    test "with the auto-check for signed signature", %{hash: hash, sig: sig, pub_key: pub_key} do
      %SignCommand{command: %SignatureWithHash{signature: %SignedSignatureWithHash{}}} =
        SignCommand.new(hash: hash, sig: sig, pub_key: pub_key)
    end

    test "with the auto-check for unsigned signature", %{hash: hash, sig: sig} do
      %SignCommand{command: %SignatureWithHash{signature: %UnsignedSignatureWithHash{}}} =
        SignCommand.new(hash: hash, sig: sig)
    end

    test "with an incomplete list", %{hash: hash, pub_key: pub_key} do
      {:error, :invalid_sign_command} = SignCommand.new(hash: hash, pub_key: pub_key)
    end

    test "with an invalid hash in list", %{sig: sig, pub_key: pub_key} do
      {:error, :invalid_sign_command} = SignCommand.new(hash: 123, sig: sig, pub_key: pub_key)
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
