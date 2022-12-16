defmodule Kadena.Chainweb.Pact.CommandPayloadTest do
  @moduledoc """
  `CommandPayload` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.{CommandPayload, JSONPayload}

  alias Kadena.Types.{
    ContPayload,
    ExecPayload,
    MetaData,
    NetworkID,
    PactPayload,
    SignersList
  }

  describe "new/1" do
    setup do
      # Payload args
      data = nil
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

      signers_list_value = [
        [pub_key: base16string, scheme: signer_scheme, addr: base16string, clist: clist]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      # MetaData args
      creation_time = 0
      ttl = 0
      gas_limit = 2500
      gas_price = 1.0e-2
      sender = "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca"
      chain_id = "0"

      meta = [
        creation_time: creation_time,
        ttl: ttl,
        gas_limit: gas_limit,
        gas_price: gas_price,
        sender: sender,
        chain_id: chain_id
      ]

      %{
        network_id: :mainnet01,
        network_id_nil: nil,
        network_id_str: "mainnet01",
        cont_payload:
          ContPayload.new(
            data: data,
            pact_id: pact_id,
            step: step,
            proof: proof,
            rollback: rollback
          ),
        exec_payload: ExecPayload.new(data: data, code: code),
        signers: signers_list_value,
        signers_list_struct: signer_list_struct,
        meta: MetaData.new(meta),
        meta_list: meta,
        nonce: "valid_nonce"
      }
    end

    test "with valid params with NetworkID", %{
      network_id: network_id,
      network_id_str: network_id_str,
      exec_payload: exec_payload,
      signers: signers,
      signers_list_struct: signers_list_struct,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^exec_payload},
        signers: ^signers_list_struct,
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: NetworkID.new(network_id),
          payload: exec_payload,
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with valid params with exec payload", %{
      network_id: network_id,
      network_id_str: network_id_str,
      exec_payload: exec_payload,
      signers: signers,
      signers_list_struct: signers_list_struct,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^exec_payload},
        signers: ^signers_list_struct,
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

    test "with valid params with PactPayload", %{
      network_id: network_id,
      network_id_str: network_id_str,
      exec_payload: exec_payload,
      signers: signers,
      signers_list_struct: signers_list_struct,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^exec_payload},
        signers: ^signers_list_struct,
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: network_id,
          payload: PactPayload.new(exec_payload),
          signers: signers,
          meta: meta,
          nonce: nonce
        )
    end

    test "with valid params with cont payload", %{
      network_id: network_id,
      network_id_str: network_id_str,
      cont_payload: cont_payload,
      signers: signers,
      signers_list_struct: signers_list_struct,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^cont_payload},
        signers: ^signers_list_struct,
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

    test "with valid params and signer list struct", %{
      network_id: network_id,
      network_id_str: network_id_str,
      cont_payload: cont_payload,
      signers_list_struct: signers_list_struct,
      meta: meta,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^cont_payload},
        signers: ^signers_list_struct,
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers_list_struct,
          meta: meta,
          nonce: nonce
        )
    end

    test "with valid params and MetaData", %{
      network_id: network_id,
      network_id_str: network_id_str,
      cont_payload: cont_payload,
      signers_list_struct: signers_list_struct,
      signers: signers,
      meta: meta,
      meta_list: meta_list,
      nonce: nonce
    } do
      %CommandPayload{
        network_id: %NetworkID{id: ^network_id_str},
        payload: %PactPayload{payload: ^cont_payload},
        signers: ^signers_list_struct,
        meta: ^meta,
        nonce: ^nonce
      } =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers,
          meta: meta_list,
          nonce: nonce
        )
    end

    test "with invalid network_id", %{
      cont_payload: cont_payload,
      signers: signers,
      meta: meta,
      nonce: nonce
    } do
      {:error, [network_id: :invalid]} =
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
      {:error, [payload: :invalid]} =
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
      {:error, [signers: :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers ++ [["invalid_signer_args"]],
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
      {:error, [meta: :invalid]} =
        CommandPayload.new(
          network_id: network_id,
          payload: cont_payload,
          signers: signers,
          meta: "invalid_meta",
          nonce: nonce
        )
    end

    test "with required values", %{
      cont_payload: cont_payload,
      signers_list_struct: signers_list_struct,
      signers: signers
    } do
      %CommandPayload{
        network_id: %NetworkID{id: nil},
        payload: %PactPayload{payload: ^cont_payload},
        signers: ^signers_list_struct,
        meta: %MetaData{},
        nonce: ""
      } =
        CommandPayload.new(
          payload: cont_payload,
          signers: signers
        )
    end
  end

  describe "JSONPayload.parse/1" do
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
        signer_scheme: signer_scheme,
        exec_payload: ExecPayload.new(data: %{}, code: "(+ 5 6)")
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
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: [pub_key]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":["#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}"],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a PactInt", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: [9_007_199_254_740_992]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":[9007199254740992],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a PactDecimal", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: ["9007199254740992.553"]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":["#{"9007199254740992.553"}"],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a PactValuesList", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: [["9007199254740992.553"]]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":[["#{"9007199254740992.553"}"]],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a nil addr", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: [pub_key]]

      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: nil, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":null,"clist":[{"args":["#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}"],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a nil schema", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      exec_payload: exec_payload
    } do
      cap_value = [name: "coin.GAS", args: [pub_key]]

      signers_list_value = [
        [pub_key: pub_key, scheme: nil, addr: pub_key, clist: [cap_value]]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":["#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}"],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":null}]}) =
        JSONPayload.parse(command_payload)
    end

    test "with a nil clist", %{
      creation_time: creation_time,
      ttl: ttl,
      gas_limit: gas_limit,
      gas_price: gas_price,
      sender: sender,
      chain_id: chain_id,
      pub_key: pub_key,
      signer_scheme: signer_scheme,
      exec_payload: exec_payload
    } do
      signers_list_value = [
        [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: nil]
      ]

      signer_list_struct = SignersList.new(signers_list_value)

      command_payload =
        CommandPayload.new(
          network_id: :testnet04,
          payload: exec_payload,
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":{}}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
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
      cap_value = [name: "coin.GAS", args: [pub_key]]

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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{"exec":{"code":"#{"(+ 5 6)"}","data":null}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":["#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}"],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":"valid_proof",\"rollback\":true,\"step\":2}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":[["#{"9007199254740992.553"}"]],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
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

      ~s({"meta":{"chainId":"0","creationTime":1667249173,"gasLimit":1000,"gasPrice":1.0e-6,"sender":"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94","ttl":28800},"networkId":"testnet04","nonce":"2023-06-13 17:45:18.211131 UTC","payload":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":true,\"step\":2}},"signers":[{"addr":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","clist":[{"args":[["#{"9007199254740992.553"}"]],"name":"coin.GAS"}],"pubKey":"#{"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"}","scheme":"ED25519"}]}) =
        JSONPayload.parse(command_payload)
    end
  end
end
