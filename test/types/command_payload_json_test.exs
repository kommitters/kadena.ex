defmodule Kadena.Types.CommandPayloadJSONTest do
  @moduledoc """
  `CommandPayloadJSON` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{
    CommandPayload,
    CommandPayloadJSON,
    ContPayload,
    ExecPayload,
    MetaData,
    SignersList
  }

  describe "new/1" do
    setup do
      pub_key = "85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"

      signer_scheme = :ed25519

      # MetaData args
      creation_time = 1_667_249_173
      ttl = 28_800
      gas_limit = 1000
      gas_price = 0.000001
      sender = "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94"
      chain_id = "0"

      %{
        creation_time: creation_time,
        ttl: ttl,
        gas_limit: gas_limit,
        gas_price: gas_price,
        sender: sender,
        chain_id: chain_id,
        pub_key: pub_key,
        signer_scheme: signer_scheme
      }
    end

    test "with a valid value", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [pub_key]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a PactInt", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [9_007_199_254_740_992]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[9007199254740992],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a PactDecimal", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: ["9007199254740992.553"]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"9007199254740992.553\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a PactValuesList", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a nil addr", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: nil, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a nil schema", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: nil, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":null}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a nil clist", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: nil]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: %{}, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a nil data", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: ExecPayload.new(data: nil, code: "(+ 5 6)"),
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a ContPayload", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      cont_payload =
        ContPayload.new(
          data: %{},
          pact_id: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
          step: 2,
          proof: "valid_proof",
          rollback: true
        )

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: cont_payload,
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":\"valid_proof\",\"roollback\":true,\"step\":2}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end

    test "with a nil proof", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      cont_payload =
        ContPayload.new(
          data: %{},
          pact_id: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
          step: 2,
          proof: nil,
          rollback: true
        )

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: cont_payload,
          signers: signer_list_struct,
          meta:
            MetaData.new(
              creation_time: creation_time,
              ttl: ttl,
              gas_limit: gas_limit,
              gas_price: gas_price,
              sender: sender,
              chain_id: chain_id
            ),
          nonce: "2023-06-13 17:45:18.211131 UTC"
        )

      %CommandPayloadJSON{
        json:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"roollback\":true,\"step\":2}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[[\"9007199254740992.553\"]],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      } = CommandPayloadJSON.new(command_payload)
    end
  end
end
