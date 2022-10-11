defmodule Kadena.Types.SignatureWithHashTest do
  @moduledoc """
  `SignatureWithHash` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.SignatureWithHash

  describe "new/1" do
    setup do
      %{
        hash: "JHgnKe5Wd4hNIb7a6bIhm4ifxsYFzVGtAMyi_TEO-oM",
        sig:
          "13a8c30a12077831a4e458f653850bcee75aec442075d24bfb6d5c54c0e5bd59deaa2b2301a99f26d15ec32ad3a581352430f163cf9401d07ce132f7b38df00e",
        pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
      }
    end

    test "with a valid list", %{hash: hash, sig: sig, pub_key: pub_key} do
      %SignatureWithHash{hash: ^hash, sig: ^sig, pub_key: ^pub_key, type: :signed_signature} =
        SignatureWithHash.new(hash: hash, sig: sig, pub_key: pub_key)
    end

    test "with a valid list without pub_key", %{hash: hash, sig: sig} do
      %SignatureWithHash{hash: ^hash, sig: ^sig, pub_key: nil, type: :unsigned_signature} =
        SignatureWithHash.new(hash: hash, sig: sig)
    end

    test "with an empty list value" do
      {:error, [hash: :invalid]} = SignatureWithHash.new([])
    end

    test "with an invalid hash value", %{sig: sig} do
      {:error, [hash: :invalid]} = SignatureWithHash.new(sig: sig)
    end

    test "with an invalid sig value", %{hash: hash} do
      {:error, [sig: :invalid]} = SignatureWithHash.new(hash: hash)
    end
  end
end
