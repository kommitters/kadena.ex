defmodule Kadena.Types.CommandPayloadTest do
  @moduledoc """
  `CommandPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{CommandPayload, ChainwebNetworkID, ContPayload, ExecPayload, PactPayload, Signer, SignerList, MetaData}

  describe "new/1" do
    setup do
      # Payload args
      data = %{},
      code = "(format \"hello {}\" [\"world\"])"
      pact_id = "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
      step = 2,
      proof = "valid_proof",
      rollback = true

      # Signer args
      cap_value = {"valid_name", ["valid_value", "valid_value", "valid_value"]}
      clist = [cap_value, cap_value, cap_value]
      base16string = "64617373646164617364617364616473616461736461736464",
      signer_scheme = :ED25519

      # MetaData args
      creation_time = 0
      ttl = 0
      gas_limit = 2500
      gas_price = 1.0e-2
      sender = "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca"
      chain_id  "0"

      %{
        network_id: :mainnet01,
        exec_payload: ContPayload.new(data: data, pact_id: pact_id, step: step, proof: proof, rollback: rollback),
        cont_payload: ExecPayload.new(data: data, code: code),
        signers: [Signer.new(pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist)],
        data: MetaData.new(creation_time: creation_time, ttl: ttl, gas_limit: gas_limit, gas_price: gas_price, sender: sender, chain_id: chain_id),
        nonce: "valid_nonce"
      }
    end

    test "with valid params with exec payload", %{network_id: network_id, exec_payload: exec_payload, signers: signers, data: data, nonce: nonce} do
      %CommandPayload{%ChainwebNetworkID{id: ^network_id}, %PactPayload{payload: ^exec_payload}, signers: %SignerList{list: ^signers}, data: ^data, nonce: ^nonce} = CommandPayload.new(network_id: network_id, payload: exec_payload, signers: signers, data: data, nonce: nonce)
    end

    test "with valid params with cont payload", %{network_id: network_id, cont_payload: cont_payload, signers: signers, data: data, nonce: nonce} do
      %CommandPayload{%ChainwebNetworkID{id: ^network_id}, %PactPayload{payload: ^cont_payload}, signers: %SignerList{list: ^signers}, data: ^data, nonce: ^nonce} = CommandPayload.new(network_id: network_id, payload: cont_payload, signers: signers, data: data, nonce: nonce)
    end
  end
end
