defmodule Kadena.Types.SignerTest do
  @moduledoc """
  `Signer` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base16String, Cap, Signer}

  describe "new/1" do
    setup do
      cap_data = [name: "gas", args: ["COIN.gas", 0.02]]
      cap = Cap.new(cap_data)
      caps_list = [cap, cap, cap]
      caps_list2 = [cap]

      %{
        base16string: "64617373646164617364617364616473616461736461736464",
        signer_scheme: :ed25519,
        caps_list: caps_list,
        caps_list2: caps_list2
      }
    end

    test "with valid list params", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      caps_list: caps_list
    } do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: ^signer_scheme,
        addr: %Base16String{value: ^base16string},
        clist: ^caps_list
      } =
        Signer.new(
          pub_key: base16string,
          scheme: signer_scheme,
          addr: base16string,
          clist: caps_list
        )
    end

    test "with valid map params", %{
      base16string: base16string,
      signer_scheme: signer_scheme
    } do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: ^signer_scheme,
        addr: %Base16String{value: ^base16string},
        clist: nil
      } =
        Signer.new(%{
          "publicKey" => base16string,
          "scheme" => signer_scheme,
          "addr" => base16string,
          "clist" => nil
        })
    end

    test "with caps_data map from map params", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      caps_list2: caps_list2
    } do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: ^signer_scheme,
        addr: %Base16String{value: ^base16string},
        clist: ^caps_list2
      } =
        Signer.new(%{
          "publicKey" => base16string,
          "scheme" => signer_scheme,
          "addr" => base16string,
          "capsList" => [%{name: "gas", args: ["COIN.gas", 0.02]}]
        })
    end

    test "with only the required valid params", %{base16string: base16string} do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: nil,
        addr: nil,
        clist: nil
      } = Signer.new(pub_key: base16string)
    end

    test "with invalid pub key", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      caps_list: caps_list
    } do
      {:error, [pub_key: :invalid]} =
        Signer.new(pub_key: 12_345, scheme: signer_scheme, addr: base16string, clist: caps_list)
    end

    test "with invalid scheme", %{
      base16string: base16string,
      caps_list: caps_list
    } do
      {:error, [scheme: :invalid]} =
        Signer.new(
          pub_key: base16string,
          scheme: :INVALID_SCHEMA,
          addr: base16string,
          clist: caps_list
        )
    end

    test "with invalid addr", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      caps_list: caps_list
    } do
      {:error, [addr: :invalid]} =
        Signer.new(pub_key: base16string, scheme: signer_scheme, addr: 12_345, clist: caps_list)
    end

    test "with invalid clist", %{
      base16string: base16string,
      signer_scheme: signer_scheme
    } do
      {:error, [clist: :not_a_caps_list]} =
        Signer.new(
          pub_key: base16string,
          scheme: signer_scheme,
          addr: base16string,
          clist: "invalid_clist"
        )
    end
  end
end
