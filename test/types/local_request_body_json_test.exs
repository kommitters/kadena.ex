defmodule Kadena.Types.LocalRequestBodyJSONTest do
  @moduledoc """
  `LocalRequestBodyJSON` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.Sign

  alias Kadena.Types.{
    CommandPayload,
    CommandPayloadJSON,
    ExecPayload,
    KeyPair,
    LocalRequestBody,
    LocalRequestBodyJSON,
    MetaData,
    SignCommand,
    SignersList
  }

  describe "new/1" do
    setup do
      pub_key = "85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"

      keypair =
        KeyPair.new(
          pub_key: pub_key,
          secret_key: "53d1e1639bd6c607d33f3efcbaafc6d0d4fb022cd57a3a9b8534ddcd8c471902"
        )

      signer_scheme = :ed25519

      # MetaData args
      creation_time = 1_667_249_173
      ttl = 28_800
      gas_limit = 1000
      gas_price = 0.000001
      sender = "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94"
      chain_id = "0"

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

      %CommandPayloadJSON{json: cmd} = CommandPayloadJSON.new(command_payload)

      {:ok, %SignCommand{hash: hash, sig: sig}} = Sign.sign(cmd, keypair)

      %{
        local_request_body:
          LocalRequestBody.new(
            hash: hash,
            sigs: [sig],
            cmd: cmd
          )
      }
    end

    test "With valid LocalRequestBody struct", %{local_request_body: local_request_body} do
      %LocalRequestBodyJSON{
        json:
          "{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"0\\\",\\\"creationTime\\\":1667249173,\\\"gasLimit\\\":1000,\\\"gasPrice\\\":1.0e-6,\\\"sender\\\":\\\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\\\",\\\"ttl\\\":28800},\\\"networkId\\\":\\\"testnet04\\\",\\\"nonce\\\":\\\"2023-06-13 17:45:18.211131 UTC\\\",\\\"payload\\\":{\\\"exec\\\":{\\\"code\\\":\\\"(+ 5 6)\\\",\\\"data\\\":{}}},\\\"signers\\\":[{\\\"addr\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"clist\\\":[{\\\"args\\\":[\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\"],\\\"name\\\":\\\"coin.GAS\\\"}],\\\"pubKey\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"scheme\\\":\\\"ED25519\\\"}]}\",\"hash\":\"-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk\",\"sigs\":[{\"sig\":\"8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d\"}]}"
      } = LocalRequestBodyJSON.new(local_request_body)
    end
  end
end
