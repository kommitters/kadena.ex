defmodule Kadena.Types.SignerTest do
  @moduledoc """
  `Signer` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Base16String, Cap, Signer}

  describe "new/1" do
    setup do
      value = "valid_value" |> PactLiteral.new() |> PactValue.new()
      values_list = PactValuesList.new([value, value, value])

      %{
        base16string: "64617373646164617364617364616473616461736461736464",
        signer_scheme: :ED25519,
        clist: [Cap.new(name: "valid_name", args: values_list), Cap.new(name: "valid_name2", args: values_list)]
      }
    end

    test "with valid params", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      %Signer{pub_key: %Base16String{value: ^base16string}, scheme: ^signer_scheme, addr: %Base16String{value: ^base16string}, clist: ^clist} = Signer.new(pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist)
    end

    test "with only the required valid params", %{base16string: base16string} do
      %Signer{pub_key: %Base16String{value: ^base16string}, scheme: nil, addr: nil, clist: []} = Signer.new(pub_key: base16string)
    end

    test "with invalid pub key", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      {:error, :invalid_pub_key} = Signer.new(pub_key: 12345, scheme: signer_scheme, addr: base16string, clist: clist)
    end

    test "with invalid scheme", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      {:error, :invalid_scheme} = Signer.new(pub_key: base16string, scheme: :INVALID_SCHEMA, addr: base16string, clist: clist)
    end

    test "with invalid addr", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      {:error, :invalid_addr} = Signer.new(pub_key: base16string, scheme: signer_scheme, addr: 12345, clist: clist)
    end

    test "with invalid clist", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      {:error, :invalid_clist} = Signer.new(pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: "invalid_clist")
    end

    test "with invalid clist list", %{base16string: base16string, signer_scheme: signer_scheme, clist: clist} do
      {:error, :invalid_clist} = Signer.new(pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist ++ ["invalid_clist"])
    end
  end
end
