defmodule Kadena.Types.SignedSignatureWithHashTest do
  @moduledoc """
  `SignedSignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignedSignatureWithHash}

  describe "new/1" do
    setup do
      %{sig: Signature.new("valid signature")}
    end

    test "with a valid signature keys", %{sig: sig} do
      %SignedSignatureWithHash{hash: "valid_hash", sig: ^sig, pub_key: "valid_public_key"} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: sig,
          pub_key: "valid_public_key"
        )
    end

    test "with a nil signature" do
      undefined_signature = Signature.new()

      %SignedSignatureWithHash{
        hash: "valid_hash",
        sig: ^undefined_signature,
        pub_key: "valid_public_key"
      } =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: undefined_signature,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid hash", %{sig: sig} do
      {:error, :invalid_signed_signature} =
        SignedSignatureWithHash.new(
          hash: 123,
          sig: sig,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid sig" do
      {:error, :invalid_signed_signature} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: 123,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid public key", %{sig: sig} do
      {:error, :invalid_signed_signature} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: sig,
          pub_key: 123
        )
    end

    test "with an empty list" do
      {:error, :invalid_signed_signature} = SignedSignatureWithHash.new([])
    end

    test "with an incomplete list" do
      {:error, :invalid_signed_signature} =
        SignedSignatureWithHash.new(hash: "valid_hash", pub_key: "valid_public_key")
    end
  end
end
