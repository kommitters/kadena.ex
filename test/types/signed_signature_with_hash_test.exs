defmodule Kadena.Types.SignedSignatureWithHashTest do
  @moduledoc """
  `SignedSignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.SignedSignatureWithHash

  describe "new/1" do
    test "With valid signature with hash" do
      %SignedSignatureWithHash{hash: "valid_hash", sig: "valid_sig", pubKey: "valid_pubic_key"} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: "valid_sig",
          pubKey: "valid_pubic_key"
        )
    end

    test "With invalid hash" do
      {:error, :invalid_hash} =
        SignedSignatureWithHash.new(
          hash: 123,
          sig: "valid_sig",
          pubKey: "valid_pubic_key"
        )
    end

    test "With invalid sig" do
      {:error, :invalid_sig} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: 123,
          pubKey: "valid_pubic_key"
        )
    end

    test "With invalid public key" do
      {:error, :invalid_public_key} =
        SignedSignatureWithHash.new(
          hash: "valid_hash",
          sig: "valid_sig",
          pubKey: 123
        )
    end

    test "With invalid data" do
      {:error, :invalid_hash} =
        SignedSignatureWithHash.new(
          hash: :hash,
          sig: 1064,
          pubKey: nil
        )
    end

    test "With empty list" do
      {:error, :invalid_signature} = SignedSignatureWithHash.new([])
    end

    test "With incomplete list" do
      {:error, :invalid_signature} = SignedSignatureWithHash.new(hash: "valid_hash")
    end
  end
end
