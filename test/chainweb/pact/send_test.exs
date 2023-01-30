defmodule Kadena.Chainweb.Client.CannedSendRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/1/pact/api/v1/send",
        _headers,
        "{\"cmds\":[{\"cmd\":\"{\\\"meta\\\":{\\\"chainId\\\":\\\"1\\\",\\\"creationTime\\\":1675093790,\\\"gasLimit\\\":1000,\\\"gasPrice\\\":1.0e-6,\\\"sender\\\":\\\"k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7\\\",\\\"ttl\\\":28800},\\\"networkId\\\":\\\"testnet04\\\",\\\"nonce\\\":\\\"2022-01-01 00:00:00.000000 UTC\\\",\\\"payload\\\":{\\\"exec\\\":{\\\"code\\\":\\\"(+ 1 10)\\\",\\\"data\\\":null}},\\\"signers\\\":[{\\\"addr\\\":null,\\\"clist\\\":[],\\\"pubKey\\\":\\\"d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7\\\",\\\"scheme\\\":\\\"ED25519\\\"}]}\",\"hash\":\"64rRUBVnKEJOw0-zjqqAoFz5KRPHN95uPRt9hNi44jM\",\"sigs\":[{\"sig\":\"9d034184bac92b896d22a3ba6473955e5080e8341d3016cf43bc9c62de69a8796dd4efc1ab23cd9db2521cca9bd5d271c24a0981daa749d11e9ab18385cdd907\"}]}]}",
        _options
      ) do
    response = Chainweb.fixture("send_2")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/1/pact/api/v1/send",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("send")
    {:ok, response}
  end

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/pact/api/v1/send",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Validation failed for hash \"VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc\": Transaction metadata (chain id, chainweb version) conflicts with this endpoint"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.Pact.SendTest do
  @moduledoc """
  `Send` endpoint implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedSendRequests
  alias Kadena.Chainweb.{Error, Pact}
  alias Kadena.Chainweb.Pact.SendResponse
  alias Kadena.Cryptography
  alias Kadena.Pact.ExecCommand
  alias Kadena.Types.MetaData

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedSendRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    network_id = :testnet04
    code = "(+ 1 2)"
    nonce = "2023-01-01 00:00:00.000000 UTC"

    {:ok, keypair} =
      Cryptography.KeyPair.from_secret_key(
        "28834b7a0d6d1f84ae2c2efcb5b1de28122e07e2e4caad04a32988a3c79c547c"
      )

    meta_data =
      MetaData.new(
        creation_time: 1_671_462_208,
        ttl: 28_800,
        gas_limit: 1000,
        gas_price: 0.000001,
        sender: "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
        chain_id: "1"
      )

    {:ok, cmd1} =
      ExecCommand.new()
      |> ExecCommand.set_network(network_id)
      |> ExecCommand.set_code(code)
      |> ExecCommand.set_nonce(nonce)
      |> ExecCommand.set_metadata(meta_data)
      |> ExecCommand.add_keypair(keypair)
      |> ExecCommand.build()

    code = "(+ 2 2)"

    {:ok, cmd2} =
      ExecCommand.new()
      |> ExecCommand.set_network(network_id)
      |> ExecCommand.set_code(code)
      |> ExecCommand.set_nonce(nonce)
      |> ExecCommand.set_metadata(meta_data)
      |> ExecCommand.add_keypair(keypair)
      |> ExecCommand.build()

    {:ok, cmd_from_yaml} =
      ExecCommand.from_yaml("test/support/yaml_tests_files/for_test_send.yaml")
      |> ExecCommand.build()

    %{
      cmds: [cmd1, cmd2],
      cmd_yaml: [cmd_from_yaml]
    }
  end

  test "process/2", %{cmds: cmds} do
    {:ok,
     %SendResponse{
       request_keys: [
         "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc",
         "gyShUgtFBk5xDoiBoLURbU_5vUG0benKroNDRhz8wqA"
       ]
     }} = Pact.send(cmds, network_id: :testnet04, chain_id: 1)
  end

  test "process with a ExecCommand from a YAML file", %{cmd_yaml: cmd_yaml} do
    {:ok,
     %SendResponse{
       request_keys: ["64rRUBVnKEJOw0-zjqqAoFz5KRPHN95uPRt9hNi44jM"]
     }} = Pact.send(cmd_yaml, network_id: :testnet04, chain_id: 1)
  end

  test "process/2 conflict with chain_id", %{cmds: cmds} do
    {:error,
     %Error{
       status: 400,
       title:
         "Validation failed for hash \"VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc\": Transaction metadata (chain id, chainweb version) conflicts with this endpoint"
     }} = Pact.send(cmds)
  end
end
