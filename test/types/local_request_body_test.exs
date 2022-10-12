defmodule Kadena.Types.LocalRequestBodyTest do
  @moduledoc """
  `LocalRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    CommandPayloadStringifiedJSON,
    LocalRequestBody,
    PactTransactionHash,
    SignaturesList
  }

  describe "new/1" do
    setup do
      %{
        hash: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
        sigs: [
          "0df98906e0c7a6e380f72dac6211b37c321f6555f3eb20ee2736f37784a3edda54da3a15398079b44f474b1fc7f522ffa3ae004a67a0a0266ecc8c82b9a0220b"
        ],
        cmd:
          "\"networkId\":\"development\",\"payload\":{\"exec\":{\"data\":null,\"code\":\"(+ 1 2)\"}},\"signers\":[{\"pubKey\":\"f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"}],\"meta\":{\"creationTime\":1655142318,\"ttl\":28800,\"gasLimit\":10000,\"chainId\":\"0\",\"gasPrice\":1.0e-5,\"sender\":\"k:f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"},\"nonce\":\"2022-06-13 17:45:18.211131 UTC\"}"
      }
    end

    test "with a valid params list", %{hash: hash, sigs: sigs, cmd: cmd} do
      %LocalRequestBody{
        cmd: %CommandPayloadStringifiedJSON{json_string: ^cmd},
        hash: %PactTransactionHash{hash: ^hash},
        sigs: %SignaturesList{}
      } = LocalRequestBody.new(hash: hash, sigs: sigs, cmd: cmd)
    end

    test "with an invalid no list params" do
      {:error, [local_request_body: :not_a_list]} = LocalRequestBody.new("No list")
    end

    test "with an invalid cmd", %{hash: hash, sigs: sigs} do
      {:error, [cmd: :invalid, json_string: :invalid]} =
        LocalRequestBody.new(hash: hash, sigs: sigs, cmd: 123)
    end

    test "with an invalid hash", %{sigs: sigs, cmd: cmd} do
      {:error, [hash: :invalid]} = LocalRequestBody.new(hash: 123, sigs: sigs, cmd: cmd)
    end

    test "with an invalid sigs list", %{hash: hash, cmd: cmd} do
      {:error, [sigs: :invalid, signatures: :invalid, sig: :invalid]} =
        LocalRequestBody.new(hash: hash, sigs: [invalid_signature: :invalid_value], cmd: cmd)
    end
  end
end
