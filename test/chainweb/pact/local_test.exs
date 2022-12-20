defmodule Kadena.Chainweb.Client.CannedLocalRequests do
  @moduledoc false

  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/1/pact/api/v1/local",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("local")
    {:ok, response}
  end
end

defmodule Kadena.Chainweb.Pact.LocalTest do
  @moduledoc """
  `Local` endpoint implementation tests.
  """
  use ExUnit.Case
  alias Kadena.Chainweb.Client.CannedLocalRequests
  alias Kadena.Chainweb.Pact
  alias Kadena.Chainweb.Pact.LocalResponse
  alias Kadena.Cryptography
  alias Kadena.Pact.ExecCommand
  alias Kadena.Types.MetaData

  setup do
    Application.put_env(:kadena, :http_client_impl, CannedLocalRequests)

    on_exit(fn ->
      Application.delete_env(:kadena, :http_client_impl)
    end)

    network_id = :testnet04
    code = "(+ 5 6)"
    nonce = "2023-06-13 17:45:18.211131 UTC"

    {:ok, keypair} =
      Cryptography.KeyPair.from_secret_key(
        "28834b7a0d6d1f84ae2c2efcb5b1de28122e07e2e4caad04a32988a3c79c547c"
      )

    meta_data =
      MetaData.new(
        creation_time: 1_671_462_208,
        ttl: 28_800,
        gas_limit: 1000,
        gas_price: 1.0e-6,
        sender: "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
        chain_id: "1"
      )

    cmd =
      ExecCommand.new()
      |> ExecCommand.set_network(network_id)
      |> ExecCommand.set_code(code)
      |> ExecCommand.set_nonce(nonce)
      |> ExecCommand.set_metadata(meta_data)
      |> ExecCommand.add_keypair(keypair)
      |> ExecCommand.build()

    %{
      cmd: cmd,
      local_response:
        {:ok,
         %LocalResponse{
           continuation: nil,
           events: nil,
           gas: 6,
           logs: "wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8",
           meta_data: %{
             block_height: 3_303_861,
             block_time: 1_671_546_034_831_940,
             prev_block_hash: "Y6Wj0sxJpdV8M-3ihAbzUka57Wv5ZV2Uez6H_6_WeeY",
             public_meta: %{
               chain_id: "1",
               creation_time: 1_671_462_208,
               gas_limit: 1000,
               gas_price: 1.0e-6,
               sender: "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
               ttl: 28_800
             }
           },
           req_key: "SvVzKL5KC0r1JdIkJDhMHT8vZhmO2CdTxPKX-6YmGG0",
           result: %{data: 11, status: "success"},
           tx_id: nil
         }}
    }
  end

  test "process/2", %{
    cmd: cmd,
    local_response: local_response
  } do
    ^local_response = Pact.local(cmd, network_id: :testnet04, chain_id: 1)
  end
end
