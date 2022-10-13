defmodule Kadena.Types.SendRequestBodyTest do
  @moduledoc """
  `SendRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Command, CommandsList, SendRequestBody}

  describe "new/1" do
    setup do
      command =
        Command.new(
          hash: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
          sigs: [
            "0df98906e0c7a6e380f72dac6211b37c321f6555f3eb20ee2736f37784a3edda54da3a15398079b44f474b1fc7f522ffa3ae004a67a0a0266ecc8c82b9a0220b"
          ],
          cmd:
            "\"networkId\":\"development\",\"payload\":{\"exec\":{\"data\":null,\"code\":\"(+ 1 2)\"}},\"signers\":[{\"pubKey\":\"f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"}],\"meta\":{\"creationTime\":1655142318,\"ttl\":28800,\"gasLimit\":10000,\"chainId\":\"0\",\"gasPrice\":1.0e-5,\"sender\":\"k:f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"},\"nonce\":\"2022-06-13 17:45:18.211131 UTC\"}"
        )

      %{
        commands_list_params: [command],
        commands_list: CommandsList.new([command])
      }
    end

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
end
