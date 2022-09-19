defmodule Kadena.Types.UnsignedSignatureWithHashTest do
  @moduledoc """
  `UnsignedSignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, UnsignedSignatureWithHash}

  describe "new/1" do
    setup do
      %{sig: Signature.new("valid signature")}
    end

    test "with a valid signature keys", %{sig: sig} do
      %UnsignedSignatureWithHash{hash: "valid_hash", sig: ^sig, pub_key: "valid_public_key"} =
        UnsignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: sig,
          pub_key: "valid_public_key"
        )
    end

    test "without a public key", %{sig: sig} do
      %UnsignedSignatureWithHash{hash: "valid_hash", sig: ^sig, pub_key: nil} =
        UnsignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: sig
        )
    end

    test "with a nil signature" do
      undefined_signature = Signature.new()

      %UnsignedSignatureWithHash{
        hash: "valid_hash",
        sig: ^undefined_signature,
        pub_key: "valid_public_key"
      } =
        UnsignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: undefined_signature,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid hash", %{sig: sig} do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: 123,
          sig: sig,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid sig" do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: 123,
          pub_key: "valid_public_key"
        )
    end

    test "with an invalid public key", %{sig: sig} do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: sig,
          pub_key: 123
        )
    end

    test "with an empty list" do
      {:error, :invalid_unsigned_signature} = UnsignedSignatureWithHash.new([])
    end

    test "with an incomplete list" do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(hash: "valid_hash", pub_key: "valid_public_key")
    end
  end
end
