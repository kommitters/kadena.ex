defmodule Kadena.Types.KeypairTest do
  @moduledoc """
  `KeyPair` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{CapsList, KeyPair, OptionalCapsList}

  setup do
    clist =
      CapsList.new([
        [name: "gas", args: ["COIN.gas", 0.02]],
        [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
      ])

    %{
      pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d",
      secret_key: "99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4",
      clist: clist,
      invalid_key: "ba54b224d1924dd98403f5c751abd"
    }
  end

  describe "new/1" do
    test "with valid arguments", %{pub_key: pub_key, secret_key: secret_key, clist: clist} do
      %KeyPair{
        pub_key: ^pub_key,
        secret_key: ^secret_key,
        clist: %OptionalCapsList{clist: ^clist}
      } = KeyPair.new(pub_key: pub_key, secret_key: secret_key, clist: clist)
    end

    test "with only required arguments", %{pub_key: pub_key, secret_key: secret_key} do
      %KeyPair{pub_key: ^pub_key, secret_key: ^secret_key, clist: %OptionalCapsList{clist: nil}} =
        KeyPair.new(pub_key: pub_key, secret_key: secret_key)
    end

    test "with invalid key", %{invalid_key: invalid_key} do
      {:error, [pub_key: :invalid]} = KeyPair.new(pub_key: invalid_key, secret_key: invalid_key)
    end

    test "with invalid clist", %{pub_key: pub_key, secret_key: secret_key} do
      {:error, [clist: :invalid]} =
        KeyPair.new(pub_key: pub_key, secret_key: secret_key, clist: "invalid")
    end
  end
end
