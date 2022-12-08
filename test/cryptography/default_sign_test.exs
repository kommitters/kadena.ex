defmodule Kadena.Cryptography.DefaultSignTest do
  @moduledoc """
  `Cryptography.Sign.Default` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.Sign
  alias Kadena.Types.{KeyPair, SignCommand}

  setup do
    %{
      hash: "uolsidh4DWN-D44FoElnosL8e5-cGCGn_0l2Nct5mq8",
      sig:
        "4b0ecfbb0e8f3cb291b57abd27028ceaa221950affa39f10efbf4a5fe740d32670e94c3d3949a7e5f4f6ea692052ca110f7cb2e9a8ee2c5eff4251ed84bbfa03",
      keypair:
        KeyPair.new(
          pub_key: "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d",
          secret_key: "8693e641ae2bbe9ea802c736f42027b03f86afe63cae315e7169c9c496c17332"
        )
    }
  end

  describe "sign/2" do
    test "with a valid KeyPair", %{keypair: %{pub_key: pub_key} = keypair, hash: hash, sig: sig} do
      msg =
        "{\"networkId\":null,\"payload\":{\"exec\":{\"data\":{\"accounts-admin-keyset\":[\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\"]},\"code\":\"(define-keyset 'k (read-keyset \\\"accounts-admin-keyset\\\"))\\n(module system 'k\\n  (defun get-system-time ()\\n    (time \\\"2017-10-31T12:00:00Z\\\")))\\n(get-system-time)\"}},\"signers\":[{\"pubKey\":\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\"}],\"meta\":{\"creationTime\":0,\"ttl\":0,\"gasLimit\":0,\"chainId\":\"\",\"gasPrice\":0,\"sender\":\"\"},\"nonce\":\"\\\"step01\\\"\"}"

      {:ok,
       %SignCommand{
         hash: ^hash,
         sig: ^sig,
         pub_key: ^pub_key,
         type: :signed_signature
       }} = Sign.sign(msg, keypair)
    end

    test "without keypair", %{hash: hash} do
      msg =
        "{\"networkId\":null,\"payload\":{\"exec\":{\"data\":{\"accounts-admin-keyset\":[\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\"]},\"code\":\"(define-keyset 'k (read-keyset \\\"accounts-admin-keyset\\\"))\\n(module system 'k\\n  (defun get-system-time ()\\n    (time \\\"2017-10-31T12:00:00Z\\\")))\\n(get-system-time)\"}},\"signers\":[{\"pubKey\":\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\"}],\"meta\":{\"creationTime\":0,\"ttl\":0,\"gasLimit\":0,\"chainId\":\"\",\"gasPrice\":0,\"sender\":\"\"},\"nonce\":\"\\\"step01\\\"\"}"

      {:ok,
       %SignCommand{
         hash: ^hash,
         type: :unsigned_signature
       }} = Sign.sign(msg, nil)
    end
  end

  describe "sign_hash/2" do
    test "with a valid secret key", %{
      keypair: %{pub_key: pub_key} = keypair,
      hash: hash,
      sig: sig
    } do
      {:ok,
       %SignCommand{
         hash: ^hash,
         sig: ^sig,
         pub_key: ^pub_key,
         type: :signed_signature
       }} = Sign.sign_hash(hash, keypair)
    end
  end

  describe "verify_sign/3" do
    test "with a valid sign", %{keypair: %{pub_key: pub_key}, hash: hash, sig: sig} do
      assert Sign.verify_sign(hash, sig, pub_key)
    end

    test "with an invalid sign", %{keypair: %{pub_key: pub_key}, hash: hash} do
      refute Sign.verify_sign(
               hash,
               "4b0ecfbb0e8f3cb291b57abd27028ceaa221950affa39f10efbf4a5fe740d32670e94c3d3949a7e5f4f6ea692052ca110f7cb2e9a8ee2c5eff4251ed84bbfa55",
               pub_key
             )
    end

    test "with an invalid pub_key", %{hash: hash, sig: sig} do
      refute Sign.verify_sign(
               hash,
               sig,
               "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7432d"
             )
    end

    test "with an invalid hash", %{keypair: %{pub_key: pub_key}, sig: sig} do
      refute Sign.verify_sign("x3pOXgOR4pSwGknQF8w0FN2dZrc7Mp7hBStnyI20JuA", sig, pub_key)
    end
  end
end
