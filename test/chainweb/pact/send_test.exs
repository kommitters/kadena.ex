defmodule Kadena.Chainweb.Pact.SendTest do
  @moduledoc """
  `Pact.Send` requests tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Send

  alias Kadena.Types.{
    Command,
    CommandPayload,
    ExecPayload,
    KeyPair,
    MetaData,
    SendRequestBody,
    SendResponse,
    SignersList,
    SignCommand
  }

  alias Kadena.Cryptography.Sign

  setup do
    pub_key = "85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"

    keypair =
      KeyPair.new(
        pub_key: pub_key,
        secret_key: "53d1e1639bd6c607d33f3efcbaafc6d0d4fb022cd57a3a9b8534ddcd8c471902"
      )

    signer_scheme = :ed25519

    # MetaData args
    creation_time = System.system_time(:second)
    ttl = 28800
    gas_limit = 1000
    gas_price = 0.000001
    sender = "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94"
    chain_id = "0"

    cap_value = [name: "coin.GAS", args: [pub_key]]
    signers_list_value = [
      [pub_key: pub_key, scheme: signer_scheme, addr: pub_key, clist: [cap_value]]
    ]
    signer_list_struct = SignersList.new(signers_list_value)

    %CommandPayload{json: cmd} =
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

    {:ok, %SignCommand{hash: hash, sig: sig}} = Sign.sign(cmd, keypair)

    cmds = [
      Command.new(
        hash: hash,
        sigs: [sig],
        cmd: cmd
      )
    ]

    json = ""

    %{
      send_request_body: SendRequestBody.new(cmds),
      json: json
    }
  end

  describe "process/3" do
    test "with a valid SendRequestBody", %{send_request_body: send_request_body} do
      %SendResponse{request_keys: []} = Send.process(send_request_body)
    end
  end

  describe "prepare/1" do
    test "with a valid SendRequestBody", %{send_request_body: send_request_body, json: json} do
      ^json = Send.prepare(send_request_body)
    end
  end
end
