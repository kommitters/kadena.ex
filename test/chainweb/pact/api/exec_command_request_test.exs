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

      keypair_data = [pub_key: pub_key, secret_key: secret_key, clist: clist]

      raw_meta_data = [
        creation_time: 1_667_249_173,
        ttl: 28_800,
        gas_limit: 1000,
        gas_price: 1.0e-6,
        sender: "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94",
        chain_id: "0"
      ]

      %{
        meta_data: MetaData.new(raw_meta_data),
        raw_meta_data: raw_meta_data,
        keypair: KeyPair.new(keypair_data),
        keypair_data: keypair_data,
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
      meta_data: meta_data,
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a valid new args", %{
      meta_data: meta_data,
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
        ExecCommandRequest.new(
          network_id: :testnet04,
          data: %{},
          code: code,
          nonce: nonce,
          meta_data: meta_data,
          keypairs: [keypair],
          signers: SignersList.new([signer])
        )
        |> ExecCommandRequest.build()
    end

    test "with a signer in existing signer_list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a valid keyword list in meta_data", %{
      raw_meta_data: raw_meta_data,
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
        |> ExecCommandRequest.set_metadata(raw_meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a valid keyword list in keypair", %{
      meta_data: meta_data,
      keypair_data: keypair_data,
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair_data)
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a keypair list", %{
      meta_data: meta_data,
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypairs([keypair, keypair])
        |> ExecCommandRequest.add_signer(signer)
        |> ExecCommandRequest.build()
    end

    test "with a SignersList", %{
      meta_data: meta_data,
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers(signers_list)
        |> ExecCommandRequest.build()
    end

    test "with a signers list", %{
      meta_data: meta_data,
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
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers(signers_list)
        |> ExecCommandRequest.build()
    end

    test "with an invalid data in build function", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [exec_command_request: :invalid_payload]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network("invalid value")
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers([signer])
        |> ExecCommandRequest.build()
    end

    test "with an invalid networ_id", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [network_id: :invalid, id: :invalid]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network("invalid value")
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers([signer])
    end

    test "with an invalid data", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [data: :invalid]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_data("invalid_value")
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers([signer])
    end

    test "with an invalid code", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [code: :not_a_string]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code([code])
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers([signer])
    end

    test "with an invalid nonce", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      code: code
    } do
      {:error, [nonce: :not_a_string]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(123)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers([signer])
    end

    test "with an invalid meta_data", %{
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [meta_data: :invalid, args: :not_a_list]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata("invalid value")
        |> ExecCommandRequest.add_keypairs([keypair])
        |> ExecCommandRequest.add_signers([signer])
    end

    test "with an invalid keypair", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypair: :invalid, args: :not_a_list]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair("invalid_value")
        |> ExecCommandRequest.add_signer(signer)
    end

    test "with an invalid keypairs", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypairs: :not_a_list]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypairs("invalid_value")
        |> ExecCommandRequest.add_signer(signer)
    end

    test "with an invalid keypairs list", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypair: :invalid, args: :not_a_list]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypairs(["invalid_value"])
        |> ExecCommandRequest.add_signer(signer)
    end

    test "with an invalid signers", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code
    } do
      {:error, [signers: :invalid, signers: :invalid_type]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signers("invalid_value")
    end

    test "with an invalid signer", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code
    } do
      {:error, [signer: :invalid]} =
        ExecCommandRequest.new()
        |> ExecCommandRequest.set_network(:testnet04)
        |> ExecCommandRequest.set_data(nil)
        |> ExecCommandRequest.set_code(code)
        |> ExecCommandRequest.set_nonce(nonce)
        |> ExecCommandRequest.set_metadata(meta_data)
        |> ExecCommandRequest.add_keypair(keypair)
        |> ExecCommandRequest.add_signer("invalid_value")
    end

    test "with an invalid args list in new function" do
      {:error, [args: :not_a_list]} = ExecCommandRequest.new("invalid_value")
    end
  end
end
