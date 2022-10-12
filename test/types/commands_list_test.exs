defmodule Kadena.Types.CommandsListTest do
  @moduledoc """
  `CommandsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Command, CommandsList}

  describe "new/1" do
    setup do
      params = [
        hash: "ATGCYPMNzdGcFh9Iik73KfMkgURIxaF91Ze4sHFsH8Q",
        sigs: [
          "0df98906e0c7a6e380f72dac6211b37c321f6555f3eb20ee2736f37784a3edda54da3a15398079b44f474b1fc7f522ffa3ae004a67a0a0266ecc8c82b9a0220b"
        ],
        cmd:
          "\"networkId\":\"development\",\"payload\":{\"exec\":{\"data\":null,\"code\":\"(+ 1 2)\"}},\"signers\":[{\"pubKey\":\"f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"}],\"meta\":{\"creationTime\":1655142318,\"ttl\":28800,\"gasLimit\":10000,\"chainId\":\"0\",\"gasPrice\":1.0e-5,\"sender\":\"k:f89ef46927f506c70b6a58fd322450a936311dc6ac91f4ec3d8ef949608dbf1f\"},\"nonce\":\"2022-06-13 17:45:18.211131 UTC\"}"
      ]

      %{
        params: params,
        command: Command.new(params)
      }
    end

    test "with a valid params list", %{params: params, command: command} do
      %CommandsList{commands: [^command]} = CommandsList.new([params])
    end

    test "with a valid Command struct", %{command: command} do
      %CommandsList{commands: [^command]} = CommandsList.new([command])
    end

    test "with a valid Command struct and params list", %{params: params, command: command} do
      %CommandsList{commands: [^command, ^command]} = CommandsList.new([params, command])
    end

    test "with an invalid param in list", %{params: params} do
      {:error, [commands: :invalid, hash: :invalid]} =
        CommandsList.new([params, [invalid_param: :invalid_value]])
    end

    test "with an invalid no list params" do
      {:error, [commands: :not_a_list]} = CommandsList.new("No list")
    end
  end
end
