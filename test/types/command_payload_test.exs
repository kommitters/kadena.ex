defmodule Kadena.Types.CommandPayloadTest do
  @moduledoc """
  `CommandPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    CommandPayload,
    NetworkID,
    ContPayload,
    ExecPayload,
    PactPayload,
    Signer,
    SignersList,
    MetaData
  }

  describe "new/1" do
    setup do
      # Payload args
      data = %{}
      code = "(format \"hello {}\" [\"world\"])"
      pact_id = "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"
      step = 2
      proof = "valid_proof"
      rollback = true

      # Signer args
      cap_value = [name: "gas", args: ["COIN.gas", 0.02]]
      clist = [cap_value, cap_value, cap_value]
      base16string = "64617373646164617364617364616473616461736461736464"
      signer_scheme = :ed25519

      # MetaData args
      creation_time = 0
      ttl = 0
      gas_limit = 2500
      gas_price = 1.0e-2
      sender = "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca"
      chain_id = "0"

      %{
        network_id: :mainnet01,
        exec_payload:
          ContPayload.new(
            data: data,
            pact_id: pact_id,
            step: step,
            proof: proof,
            rollback: rollback
          ),
        cont_payload: ExecPayload.new(data: data, code: code),
        signers: [
          [pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist]
        ],
        meta:
          MetaData.new(
            creation_time: creation_time,
            ttl: ttl,
            gas_limit: gas_limit,
            gas_price: gas_price,
            sender: sender,
            chain_id: chain_id
          ),
        nonce: "valid_nonce"
      }
    end

    test "with valid params with exec payload", %{
      network_id: network_id,
      exec_payload: exec_payload,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: "Mainnet01"},
        payload: %PactPayload{payload: ^exec_payload},
        signers: %SignersList{signers: ^signers},
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: network_id,
          payload: exec_payload,
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with valid params with cont payload", %{
      network_id: network_id,
      cont_payload: cont_payload,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: "Mainnet01"},
        payload: %PactPayload{payload: ^cont_payload},
        signers: %SignersList{signers: ^signers},
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with invalid network_id", %{
      cont_payload: cont_payload,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      {:error, [:network_id, :invalid]} =
        CommandPayload.new(
          network_id: :invalid_network_id,
          payload: cont_payload,
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with invalid payload", %{
      network_id: network_id,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      {:error, [:payload, :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: "invalid_payload",
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with invalid signers", %{
      network_id: network_id,
      cont_payload: cont_payload,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      {:error, [:signers, :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers ++ ["invalid_signer"],
          meta: meta,
          nonce: nonce
        )
    end

    test "with invalid meta", %{
      network_id: network_id,
      cont_payload: cont_payload,
      signers: signers,
      nonce: nonce
    } do
      {:error, [:meta, :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers,
          meta: "invalid_meta",
          nonce: nonce
        )
    end

    test "with invalid nonce", %{
      network_id: network_id,
      cont_payload: cont_payload,
      signers: signers,
      meta: meta
    } do
      {:error, [:nonce, :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers,
          meta: meta,
          nonce: 12345
        )
    end
  end
end
