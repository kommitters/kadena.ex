defmodule Kadena.Pact.ExecCommandTest do
  @moduledoc """
  `ExecCommand` struct definition tests.
  """
  use ExUnit.Case

  alias Kadena.Cryptography.KeyPair, as: CryptographyKeyPair
  alias Kadena.Pact.ExecCommand

  alias Kadena.Types.{
    CapsList,
    Command,
    EnvData,
    KeyPair,
    MetaData,
    PactTransactionHash,
    Signature,
    SignaturesList,
    Signer,
    SignersList
  }

  describe "create ExecCommand" do
    setup do
      secret_key = "99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4"
      {:ok, %KeyPair{pub_key: pub_key}} = CryptographyKeyPair.from_secret_key(secret_key)

      clist =
        CapsList.new([
          [name: "coin.GAS", args: [pub_key]]
        ])

      keypair_data = [pub_key: pub_key, secret_key: secret_key, clist: clist]

      env_data = %{
        accounts_admin_keyset: [
          pub_key
        ]
      }

      raw_meta_data = [
        creation_time: 1_667_249_173,
        ttl: 28_800,
        gas_limit: 1000,
        gas_price: 1.0e-6,
        sender: "k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94",
        chain_id: "0"
      ]

      %{
        env_data: EnvData.new(env_data),
        meta_data: MetaData.new(raw_meta_data),
        keypair: KeyPair.new(keypair_data),
        signer:
          Signer.new(
            pub_key: pub_key,
            scheme: :ed25519,
            addr: pub_key,
            clist: clist
          ),
        code: "(+ 5 6)",
        nonce: "2023-06-13 17:45:18.211131 UTC",
        clist: clist
      }
    end

    test "with a valid pipe creation", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "2lnN17Ev5LuLUQXQ8fXNWf_Z7R0x3lrFejZ-yZMKWww"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "a4ac51052152ccff62e8dfdafe9e17df999e5b2b9cacccf2707a39a878bde0b9e18f7eff792b8863b9e9a329289f5de8eb86a8f5ff8fed399cd4258ac75b7907"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.build()
    end

    test "with a valid pipe creation, generating signers from keypairs", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code,
      env_data: env_data
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{\"accountsAdminKeyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]}}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %Kadena.Types.PactTransactionHash{
          hash: "0Q3sJAe5xqqQHqcp99BGPhL1AApvARVvBzE12FrAS54"
        },
        sigs: %Kadena.Types.SignaturesList{
          signatures: [
            %Kadena.Types.Signature{
              sig:
                "adda30e88553efa273cb640b48e5f252ccb4220b064f70164e86e7b67708bf00796fd8c5968c33c54dc2bb35a9a741da6f9c029b6f56158d6695317c9e1e2e0e"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(env_data)
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.build()
    end

    test "with a valid new args", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "2lnN17Ev5LuLUQXQ8fXNWf_Z7R0x3lrFejZ-yZMKWww"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "a4ac51052152ccff62e8dfdafe9e17df999e5b2b9cacccf2707a39a878bde0b9e18f7eff792b8863b9e9a329289f5de8eb86a8f5ff8fed399cd4258ac75b7907"
            }
          ]
        }
      } =
        ExecCommand.new(
          network_id: :testnet04,
          data: %{},
          code: code,
          nonce: nonce,
          meta_data: meta_data,
          keypairs: [keypair],
          signers: SignersList.new([signer])
        )
        |> ExecCommand.build()
    end

    test "with a signer in existing signer_list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "dj3E1TH6QPhS2YIi7tfcXj1INhcjYIFhgOitLNQEajg"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "bafbe7dbad8a82f60923331b842c3d0b973e871bc0bb56bab1e87f960d076906a07f7ce63bce41cf0d16fb0acd95d1efcd00ac3f093f5c275b2398bf40904a07"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.build()
    end

    test "with only code", %{
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[]}",
        hash: %PactTransactionHash{
          hash: "EOJAI1UaQZ3T4Zzv9V95Rhu89dI7gQqltTVA_qdHr4w"
        },
        sigs: %SignaturesList{signatures: []}
      } =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.build()
    end

    test "with keypair and without signers", %{
      code: code,
      keypair: keypair
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "lcziFYPM4wh_Vg2GtxR9guiGbYoIHhxYiI1-quGStG4"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "867ea3832b9aa32640d07be639d4ac1232fd93b26c47f50c5a82687c9ef38c6f0f9f78533fa3f2ed1028a6bdc0c0f8a980ff2a456ad42bcbac039cb50acd360a"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.build()
    end

    test "with only code and signers", %{
      code: code,
      signer: signer
    } do
      signers = SignersList.new([signer])

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "dV65hUfxM6MELiBe0hriqtzIPEzAsXqBbpKJqsusoe0"
        },
        sigs: %SignaturesList{
          signatures: []
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.add_signers(signers)
        |> ExecCommand.build()
    end

    test "with a keypair list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "p4u6YQ6rE1ytZx2aXTr8UU88UScQuA8Yn4QWeZ52nOo"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "fdd35fd60a4ce5192ef4ef739c1baf02b1b4abadd40b56df866d9311ce0e0ea1472895c87830522bba59b13a9898573e1a63890a8bc8798dccf89a158798e807"
            },
            %Signature{
              sig:
                "fdd35fd60a4ce5192ef4ef739c1baf02b1b4abadd40b56df866d9311ce0e0ea1472895c87830522bba59b13a9898573e1a63890a8bc8798dccf89a158798e807"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypairs([keypair, keypair])
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.build()
    end

    test "with a SignersList", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      signers_list = SignersList.new([signer, signer])

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "OsU2BtUACpxV8qQcIElP-Ks6ERDipQsITPwTo0CCpck"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "d05fd6227247ba9fc4277a2994d02d3ff0735888ad025fc4416c8daaae07055fe6aa34b018f9aff83d9b877ce131ff5e3032c627ae1c750e6e21e3da1b54b507"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signers(signers_list)
        |> ExecCommand.build()
    end

    test "with an invalid data in build function", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [exec_command_request: :invalid_payload]} =
        ExecCommand.new()
        |> ExecCommand.set_network("invalid value")
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.add_signers(signer)
        |> ExecCommand.build()
    end

    test "with an invalid networ_id", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [network_id: :invalid, id: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network("invalid value")
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid data", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [data: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_data("invalid_value")
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid code", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [code: :not_a_string]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code([code])
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid nonce", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      code: code
    } do
      {:error, [nonce: :not_a_string]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(123)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid meta_data", %{
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [metadata: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata("invalid value")
        |> ExecCommand.add_keypairs([keypair])
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid keypair", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypair: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair("invalid_value")
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid keypairs", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypairs: :not_a_list]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypairs("invalid_value")
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid keypairs list", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypair: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypairs(["invalid_value"])
        |> ExecCommand.add_signer(signer)
    end

    test "with an invalid signers", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code
    } do
      {:error, [signers: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signers("invalid_value")
    end

    test "with an invalid signer", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code
    } do
      {:error, [signer: :invalid]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer("invalid_value")
    end
  end
end
