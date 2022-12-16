defmodule Kadena.Chainweb.Pact.LocalTest do
  use ExUnit.Case

  alias Kadena.Chainweb.Pact

  alias Kadena.Types.{
    Command,
    PactTransactionHash,
    Signature,
    SignaturesList
  }

  describe "process/3" do
    setup do
      exec_command = %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "8b234b83570359e52188cceb301036a2a7b255171e856fd550cac687a946f18fbfc0e769fd8393dda44d6d04c31b531eaf35efb3b78b5e40fd857a743133030d"
            }
          ]
        }
      }

      %{
        exec_command: exec_command,
        continuation: nil,
        events: nil,
        gas: 7,
        logs: "wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8",
        meta_data: %{
          #   block_height: 2_815_727,
          #   block_time: 1_671_054_330_981_668,
          #   prev_block_hash: "asisNr3nuU0t357i2bxMVUiIWDVHAMtncJHtmyENbio",
          public_meta: %{
            chain_id: "0",
            creation_time: 1_667_249_173,
            gas_limit: 1000,
            gas_price: 1.0e-6,
            sender: "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94",
            ttl: 28_800
          }
        },
        req_key: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk",
        result: %{data: 11, status: "success"},
        tx_id: nil
      }
    end

    test "with a exec Command", %{
      exec_command: exec_command,
      continuation: continuation,
      events: events,
      gas: gas,
      logs: logs,
      meta_data: meta_data,
      req_key: req_key,
      result: result,
      tx_id: tx_id
    } do
      {:ok, response} = Pact.local(exec_command)
      assert(continuation == response.continuation)
      assert(events == response.events)
      assert(gas == response.gas)
      assert(logs == response.logs)
      assert(meta_data.public_meta == response.meta_data.public_meta)
      assert(req_key == response.req_key)
      assert(result == response.result)
      assert(tx_id == response.tx_id)
    end

    test "with a invalid Command", %{} do
      {:error, [command: :invalid_command]} = Pact.local(nil)
    end
  end
end
