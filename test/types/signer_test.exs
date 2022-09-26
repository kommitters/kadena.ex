defmodule Kadena.Types.SignerTest do
  @moduledoc """
  `Signer` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base16String, CapsList, CapsList, Signer}

  describe "new/1" do
    setup do
      cap_value = {"valid_name", ["valid_value", "valid_value", "valid_value"]}
      cap_list_value = [cap_value, cap_value, cap_value]
      cap_list_struct = CapsList.new(cap_list_value)

      %{
        base16string: "64617373646164617364617364616473616461736461736464",
        signer_scheme: :ed25519,
        clist: cap_list_value,
        cap_list_struct: cap_list_struct
      }
    end

    test "with valid params", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      clist: clist,
      cap_list_struct: cap_list_struct
    } do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: ^signer_scheme,
        addr: %Base16String{value: ^base16string},
        clist: ^cap_list_struct
      } =
        Signer.new(pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist)
    end

    test "with only the required valid params", %{base16string: base16string} do
      %Signer{
        pub_key: %Base16String{value: ^base16string},
        scheme: nil,
        addr: nil,
        clist: %CapsList{list: []}
      } = Signer.new(pub_key: base16string)
    end

    test "with invalid pub key", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      clist: clist
    } do
      {:error, [pub_key: :invalid]} =
        Signer.new(pub_key: 12345, scheme: signer_scheme, addr: base16string, clist: clist)
    end

    test "with invalid scheme", %{
      base16string: base16string,
      clist: clist
    } do
      {:error, [scheme: :invalid]} =
        Signer.new(
          pub_key: base16string,
          scheme: :INVALID_SCHEMA,
          addr: base16string,
          clist: clist
        )
    end

    test "with invalid addr", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      clist: clist
    } do
      {:error, [addr: :invalid]} =
        Signer.new(pub_key: base16string, scheme: signer_scheme, addr: 12345, clist: clist)
    end

    test "with invalid clist", %{
      base16string: base16string,
      signer_scheme: signer_scheme
    } do
      {:error, :invalid_clist} =
        Signer.new(
          pub_key: base16string,
          scheme: signer_scheme,
          addr: base16string,
          clist: "invalid_clist"
        )
    end

    test "with invalid clist list", %{
      base16string: base16string,
      signer_scheme: signer_scheme,
      clist: clist
    } do
      {:error, :invalid_clist} =
        Signer.new(
          pub_key: base16string,
          scheme: signer_scheme,
          addr: base16string,
          clist: clist ++ ["invalid_clist"]
        )
    end
  end
end
