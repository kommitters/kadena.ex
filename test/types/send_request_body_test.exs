defmodule Kadena.Types.SendRequestBodyTest do
  @moduledoc """
  `SendRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.JSONRequestBody
  alias Kadena.Types.{Command, CommandsList, SendRequestBody}

  setup do
    command =
      Command.new(
        hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk",
        sigs: [
          "8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d"
        ],
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}"
      )

    %{
      commands_list_params: [command],
      commands_list: CommandsList.new([command])
    }
  end

  describe "new/1" do
    test "with valid params", %{
      commands_list_params: commands_list_params,
      commands_list: commands_list
    } do
      %SendRequestBody{cmds: ^commands_list} = SendRequestBody.new(commands_list_params)
    end

    test "with valid base64 urls list struct", %{commands_list: commands_list} do
      %SendRequestBody{cmds: ^commands_list} = SendRequestBody.new(commands_list)
    end

    test "with an invalid param in list", %{commands_list_params: commands_list_params} do
      {:error, [commands: :invalid]} =
        SendRequestBody.new(commands_list_params ++ [:invalid_command])
    end

    test "with an invalid no list params" do
      {:error, [commands: :not_a_list]} = SendRequestBody.new("No list")
    end
  end

  describe "JSONRequestBody.parse/1" do
    setup do
      %{
        json_result:
          "{\"cmds\":[{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"0\\\",\\\"creationTime\\\":1667249173,\\\"gasLimit\\\":1000,\\\"gasPrice\\\":1.0e-6,\\\"sender\\\":\\\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\\\",\\\"ttl\\\":28800},\\\"networkId\\\":\\\"testnet04\\\",\\\"nonce\\\":\\\"2023-06-13 17:45:18.211131 UTC\\\",\\\"payload\\\":{\\\"exec\\\":{\\\"code\\\":\\\"(+ 5 6)\\\",\\\"data\\\":{}}},\\\"signers\\\":[{\\\"addr\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"clist\\\":[{\\\"args\\\":[\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\"],\\\"name\\\":\\\"coin.GAS\\\"}],\\\"pubKey\\\":\\\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\\\",\\\"scheme\\\":\\\"ED25519\\\"}]}\",\"hash\":\"-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk\",\"sigs\":[{\"sig\":\"8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d\"}]}]}"
      }
    end

    test "with a valid SendRequestBody", %{
      commands_list: commands_list,
      json_result: json_result
    } do
      send_request_body = SendRequestBody.new(commands_list)
      ^json_result = JSONRequestBody.parse(send_request_body)
    end
  end
end
