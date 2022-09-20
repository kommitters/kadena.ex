defmodule Kadena.Types.UnsignedSignatureWithHashTest do
  @moduledoc """
  `UnsignedSignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, UnsignedSignatureWithHash}

  describe "new/1" do
    setup do
      %{
        sig:
          Signature.new(
            "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e"
          )
      }
    end

    test "with a valid signature keys", %{sig: sig} do
      %UnsignedSignatureWithHash{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sig: ^sig,
        pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
      } =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig: sig,
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
        )
    end

    test "without a public key", %{sig: sig} do
      %UnsignedSignatureWithHash{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sig: ^sig,
        pub_key: nil
      } =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig: sig
        )
    end

    test "with a nil signature" do
      undefined_signature = Signature.new()

      %UnsignedSignatureWithHash{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sig: ^undefined_signature,
        pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
      } =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig: undefined_signature,
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
        )
    end

    test "with an invalid hash", %{sig: sig} do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: 123,
          sig: sig,
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
        )
    end

    test "with an invalid sig" do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig: 123,
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
        )
    end

    test "with an invalid public key", %{sig: sig} do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          sig: sig,
          pub_key: 123
        )
    end

    test "with an empty list" do
      {:error, :invalid_unsigned_signature} = UnsignedSignatureWithHash.new([])
    end

    test "with an incomplete list" do
      {:error, :invalid_unsigned_signature} =
        UnsignedSignatureWithHash.new(
          hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
        )
    end
  end
end
