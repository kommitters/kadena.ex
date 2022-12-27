defmodule Kadena.Chainweb.Pact.LocalRequestBodyTest do
  @moduledoc """
  `LocalRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.LocalRequestBody

  alias Kadena.Types.{
    Command,
    PactTransactionHash,
    Signature
  }

  setup do
    cmd =
      "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"

    hash = %PactTransactionHash{
      hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk"
    }

    sigs = [
      %Signature{
        sig:
          "8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d"
      }
    ]

    command = %Command{
      cmd: cmd,
      hash: hash,
      sigs: sigs
    }

    %{
      command: command,
      cmd: cmd,
      hash: hash,
      sigs: sigs,
      json_result:
        "{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"0\\\",\\\"creationTime\\\":1667249173,\\\"gasLimit\\\":1000,\\\"gasPrice\\\":1.0e-6,\\\"sender\\\":\\\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\\\",\\\"ttl\\\":28800},\\\"networkId\\\":\\\"testnet04\\\",\\\"nonce\\\":\\\"2023-06-13 17:45:18.211131 UTC\\\",\\\"payload\\\":{\\\"exec\\\":{\\\"code\\\":\\\"(+ 5 6)\\\",\\\"data\\\":{}}},\\\"signers\\\":[{\\\"addr\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"clist\\\":[{\\\"args\\\":[\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\"],\\\"name\\\":\\\"coin.GAS\\\"}],\\\"pubKey\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"scheme\\\":\\\"ED25519\\\"}]}\",\"hash\":\"-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk\",\"sigs\":[{\"sig\":\"8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d\"}]}"
    }
  end

  describe "new/1" do
    test "with a valid params list", %{command: command, hash: hash, sigs: sigs, cmd: cmd} do
      %LocalRequestBody{
        cmd: ^cmd,
        hash: ^hash,
        sigs: ^sigs
      } = LocalRequestBody.new(command)
    end

    test "with an invalid command", %{hash: hash, sigs: sigs} do
      {:error, [arg: :not_a_command]} = LocalRequestBody.new(hash: hash, sigs: sigs, cmd: 123)
    end
  end

  describe "JSONPayload.parse/1" do
    test "with a valid LocalRequestBody", %{
      command: command,
      json_result: json_result
    } do
      ^json_result =
        command
        |> LocalRequestBody.new()
        |> LocalRequestBody.to_json!()
    end
  end
end
