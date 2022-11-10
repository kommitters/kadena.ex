defmodule Kadena.Chainweb.Pact.API.ExecCommandRequestTest do
  @moduledoc """
  `ExecCommandRequest` struct definition tests.
  """
  use ExUnit.Case

  alias Kadena.Chainweb.Pact.API.{CommandRequest, ExecCommandRequest}

  alias Kadena.Types.{
    CapsList,
    ChainID,
    Command,
    KeyPair,
    MetaData,
    NetworkID,
    PactTransactionHash,
    Signature,
    SignaturesList,
    Signer,
    SignersList
  }

  describe "create ExecCommandRequest" do
    setup do
      pub_key = "85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd"
      secret_key = "99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4"

      clist =
        CapsList.new([
          [name: "coin.GAS", args: [pub_key]]
        ])

      %{
        metadata:
          MetaData.new(
            creation_time: 1_667_249_173,
            ttl: 28_800,
            gas_limit: 1000,
            gas_price: 1.0e-6,
            sender: "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94",
            chain_id: "0"
          ),
        keypair: KeyPair.new(pub_key: pub_key, secret_key: secret_key, clist: clist),
        signer:
          Signer.new(
            pub_key: pub_key,
            scheme: :ed25519,
            addr: pub_key,
            clist: clist
          ),
        code: "(+ 5 6)",
        nonce: "2023-06-13 17:45:18.211131 UTC"
      }
    end

    test "with a valid pipe creation", %{
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %CommandRequest{
        chain_id: %ChainID{id: "0"},
        cmd: %Command{
          cmd:
            "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}",
          hash: %PactTransactionHash{
            hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk"
          },
          sigs: %SignaturesList{
            signatures: [
              %Signature{
                sig:
                  "c91ade4318661acdde88f3d13b60189fbc5dc39e76bb3a64be9b9ed277b5ac84c74e373a03f4a13cf25d4944308e8f1895fe6fe891d96bd92fcef4ed87f91b0e"
              }
            ]
          }
        },
        network_id: %NetworkID{id: "testnet04"}
      } =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(%{})
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(metadata)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a keypair list", %{
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %CommandRequest{
        chain_id: %ChainID{id: "0"},
        cmd: %Command{
          cmd:
            "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}",
          hash: %PactTransactionHash{
            hash: "-1npoTU2Mi71pKE_oteJiJuHuXTXxoObJm8zzVRK2pk"
          },
          sigs: %SignaturesList{
            signatures: [
              %Signature{
                sig:
                  "c91ade4318661acdde88f3d13b60189fbc5dc39e76bb3a64be9b9ed277b5ac84c74e373a03f4a13cf25d4944308e8f1895fe6fe891d96bd92fcef4ed87f91b0e"
              },
              %Signature{
                sig:
                  "c91ade4318661acdde88f3d13b60189fbc5dc39e76bb3a64be9b9ed277b5ac84c74e373a03f4a13cf25d4944308e8f1895fe6fe891d96bd92fcef4ed87f91b0e"
              }
            ]
          }
        },
        network_id: %NetworkID{id: "testnet04"}
      } =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(%{})
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(metadata)
        |> ExecCommandRequest.add_keypairs([keypair, keypair])
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a SignersList", %{
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      signers_list = SignersList.new([signer, signer])

      %CommandRequest{
        chain_id: %ChainID{id: "0"},
        cmd: %Command{
          cmd:
            "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"},{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}",
          hash: %PactTransactionHash{
            hash: "xZ03W4owNcADN01Er6k-Q80Vm7x5iunPKs-yNKKPSdo"
          },
          sigs: %SignaturesList{
            signatures: [
              %Signature{
                sig:
                  "1b3a0224e7178c26e39274bb71fdabf6b3f4d2bea45983339969748e1c913fbf7e6cdb44f27c09af2a5d9566ef3d4ef7dcd8d9fb3e6b069a6bc603a4976bb108"
              }
            ]
          }
        },
        network_id: %NetworkID{id: "testnet04"}
      } =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(%{})
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(metadata)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers(signers_list)
        |> ExecCommandRequest.build()
    end

    test "add a signers list", %{
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      signers_list = [signer, signer]

      %CommandRequest{
        chain_id: %ChainID{id: "0"},
        cmd: %Command{
          cmd:
            "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"},{\"addr\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"clist\":[{\"args\":[\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"85bef77ea3570387cac57da34938f246c7460dc533a67823f065823e327b2afd\",\"scheme\":\"ED25519\"}]}",
          hash: %PactTransactionHash{
            hash: "xZ03W4owNcADN01Er6k-Q80Vm7x5iunPKs-yNKKPSdo"
          },
          sigs: %SignaturesList{
            signatures: [
              %Signature{
                sig:
                  "1b3a0224e7178c26e39274bb71fdabf6b3f4d2bea45983339969748e1c913fbf7e6cdb44f27c09af2a5d9566ef3d4ef7dcd8d9fb3e6b069a6bc603a4976bb108"
              }
            ]
          }
        },
        network_id: %NetworkID{id: "testnet04"}
      } =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(metadata)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers(signers_list)
        |> ExecCommandRequest.build()
    end
  end
end
