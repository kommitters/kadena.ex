defmodule Kadena.Types.SignersListTest do
  @moduledoc """
  `SignersList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base16String, CapsList, OptionalCapsList, Signer, SignersList}

  describe "new/1" do
    test "with valid params" do
      pub_key = "64617373646164617364617364616473616461736461736464"

      clist = [
        [name: "gas", args: ["COIN.gas", 0.02]],
        [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
      ]

      caps_list = CapsList.new(clist)

      signers = [
        pub_key: pub_key,
        scheme: :ed25519,
        addr: pub_key,
        clist: clist
      ]

      %SignersList{
        signers: [
          %Signer{
            pub_key: %Base16String{value: ^pub_key},
            scheme: :ed25519,
            addr: %Base16String{value: ^pub_key},
            clist: %OptionalCapsList{clist: ^caps_list}
          }
        ]
      } = SignersList.new([signers])
    end

    test "with valid params and empty list" do
      %SignersList{signers: []} = SignersList.new([])
    end

    test "with invalid signers list" do
      {:error, [signers: :invalid]} = SignersList.new([["invalid_signer"]])
    end

    test "with invalid list" do
      {:error, [signers: :invalid_type]} = SignersList.new("invalid_signers_list")
    end
  end
end
