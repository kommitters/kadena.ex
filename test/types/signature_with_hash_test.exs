defmodule Kadena.Types.SignatureWithHashTest do
  @moduledoc """
  `SignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    Signature,
    SignatureWithHash,
    SignedSignatureWithHash,
    UnsignedSignatureWithHash
  }

  describe "new/1" do
    test "with a valid SignedSignatureWithHash" do
      signed_signature =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: Signature.new("valid signature"),
          pub_key: "public_key"
        )

      %SignatureWithHash{signature: ^signed_signature} = SignatureWithHash.new(signed_signature)
    end

    test "with a valid UnsignedSignatureWithHash" do
      unsigned_signature = UnsignedSignatureWithHash.new(hash: "valid_hash", sig: Signature.new())

      %SignatureWithHash{signature: ^unsigned_signature} =
        SignatureWithHash.new(unsigned_signature)
    end

    test "with a string value" do
      {:error, :invalid_signature_with_hash} = SignatureWithHash.new("signature")
    end

    test "with a nil sig" do
      {:error, :invalid_signature_with_hash} = SignatureWithHash.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_signature_with_hash} = SignatureWithHash.new(:signature)
    end

    test "with a numeric value" do
      {:error, :invalid_signature_with_hash} = SignatureWithHash.new(123)
    end

    test "with an empty list value" do
      {:error, :invalid_signature_with_hash} = SignatureWithHash.new([])
    end
  end
end
