defmodule Kadena.Types.SignCommandTest do
  @moduledoc """
  `SignCommand` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.SignCommand

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
      %SignCommand{hash: ^hash, sig: ^sig, pub_key: ^pub_key, type: :signed_signature} =
        SignCommand.new(hash: hash, sig: sig, pub_key: pub_key)
    end

    test "with a valid list without pub_key", %{hash: hash, sig: sig} do
      %SignCommand{hash: ^hash, sig: ^sig, pub_key: nil, type: :unsigned_signature} =
        SignCommand.new(hash: hash, sig: sig)
    end

    test "with an empty list value" do
      {:error, [hash: :invalid]} = SignCommand.new([])
    end

    test "with an invalid hash value", %{sig: sig} do
      {:error, [hash: :invalid]} = SignCommand.new(sig: sig)
    end

    test "with an invalid sig value", %{hash: hash} do
      {:error, [sig: :invalid]} = SignCommand.new(hash: hash, sig: :invalid)
    end
  end
end
