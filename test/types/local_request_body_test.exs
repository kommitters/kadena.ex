defmodule Kadena.Types.LocalRequestBodyTest do
  @moduledoc """
  `LocalRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.JSONPayload

  alias Kadena.Types.{
    LocalRequestBody,
    PactTransactionHash,
    SignaturesList
  }

  setup do
    %{
      hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk",
      sigs: [
        "8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d"
      ],
      cmd:
        "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
    }
  end

  describe "new/1" do
    test "with a valid params list", %{hash: hash, sigs: sigs, cmd: cmd} do
      %LocalRequestBody{
        cmd: ^cmd,
        hash: %PactTransactionHash{hash: ^hash},
        sigs: %SignaturesList{}
      } = LocalRequestBody.new(hash: hash, sigs: sigs, cmd: cmd)
    end

    test "with an invalid no list params" do
      {:error, [local_request_body: :not_a_list]} = LocalRequestBody.new("No list")
    end

    test "with an invalid cmd", %{hash: hash, sigs: sigs} do
      {:error, [cmd: :not_a_string]} = LocalRequestBody.new(hash: hash, sigs: sigs, cmd: 123)
    end

    test "with an invalid hash", %{sigs: sigs, cmd: cmd} do
      {:error, [hash: :invalid]} = LocalRequestBody.new(hash: 123, sigs: sigs, cmd: cmd)
    end

    test "with an invalid sigs list", %{hash: hash, cmd: cmd} do
      {:error, [sigs: :invalid, signatures: :invalid, sig: :invalid]} =
        LocalRequestBody.new(hash: hash, sigs: [invalid_signature: :invalid_value], cmd: cmd)
    end
  end

  describe "JSONPayload.parse/1" do
    setup do
      %{
        json_result:
          "{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"0\\\",\\\"creationTime\\\":1667249173,\\\"gasLimit\\\":1000,\\\"gasPrice\\\":1.0e-6,\\\"sender\\\":\\\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\\\",\\\"ttl\\\":28800},\\\"networkId\\\":\\\"testnet04\\\",\\\"nonce\\\":\\\"2023-06-13 17:45:18.211131 UTC\\\",\\\"payload\\\":{\\\"exec\\\":{\\\"code\\\":\\\"(+ 5 6)\\\",\\\"data\\\":{}}},\\\"signers\\\":[{\\\"addr\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"clist\\\":[{\\\"args\\\":[\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\"],\\\"name\\\":\\\"coin.GAS\\\"}],\\\"pubKey\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"scheme\\\":\\\"ED25519\\\"}]}\",\"hash\":\"-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk\",\"sigs\":[{\"sig\":\"8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d\"}]}"
      }
    end

    test "with a valid LocalRequestBody", %{
      hash: hash,
      sigs: sigs,
      cmd: cmd,
      json_result: json_result
    } do
      local_request_body = LocalRequestBody.new(hash: hash, sigs: sigs, cmd: cmd)
      ^json_result = JSONPayload.parse(local_request_body)
    end
  end
end
