defmodule Kadena.Types.SignersListTest do
  @moduledoc """
  `SignersList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signer, SignersList}

  describe "new/1" do
    setup do
      cap_value = {"valid_name", ["valid_value", "valid_value", "valid_value"]}
      clist = [cap_value, cap_value, cap_value]
      base16string = "64617373646164617364617364616473616461736461736464"
      signer_scheme = :ed25519

      %{
        signers: [
          Signer.new(
            pub_key: base16string,
            scheme: signer_scheme,
            addr: base16string,
            clist: clist
          )
        ]
      }
    end

    test "with valid params", %{signers: signers} do
      %SignersList{list: ^signers} = SignersList.new(signers)
    end

    test "with valid params and empty list" do
      %SignersList{list: []} = SignersList.new([])
    end

    test "with invalid signers list", %{signers: signers} do
      {:error, [signers: :invalid]} = SignersList.new(signers ++ ["invalid_signer"])
    end

    test "with invalid list" do
      {:error, [signers: :invalid]} = SignersList.new("invalid_signers_list")
    end
  end
end
