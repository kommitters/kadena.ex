defmodule Kadena.Pact.API.ContCommandTest do
  @moduledoc """
  `ContCommand` struct definition tests.
  """

  use ExUnit.Case
  alias Kadena.Cryptography.KeyPair, as: CryptographyKeyPair
  alias Kadena.Pact.ContCommand

  alias Kadena.Types.{
    CapsList,
    Command,
    KeyPair,
    MetaData,
    PactTransactionHash,
    Signature,
    SignaturesList,
    Signer,
    SignersList
  }

  describe "create ContCommand" do
    setup do
      secret_key = "99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4"
      {:ok, %KeyPair{pub_key: pub_key}} = CryptographyKeyPair.from_secret_key(secret_key)

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
        metadata: MetaData.new(raw_meta_data),
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
        nonce: "2023-06-13 17:45:18.211131 UTC",
        pact_tx_hash: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4",
        clist: clist
      }
    end

    test "with a valid pipe creation", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "ugR6LZOPC36gSWWtyYTrozNWqMDFsuNyZQqV-UUEGzI"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "ffa2a279f4657428d579d7f60df4062bbbfc1c727470abb03078542c5b013bd97ffaaaf77873771be441b3a915ec6fbb7209b54aabe8f7dcb37681b0642d0e05"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with a valid new args", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      cont_command =
        ContCommand.new(
          network_id: :testnet04,
          data: %{},
          nonce: nonce,
          meta_data: metadata,
          keypairs: [keypair],
          signers: SignersList.new([signer]),
          pact_tx_hash: pact_tx_hash,
          step: 0,
          proof: "",
          rollback: false
        )

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":\"\",\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "1S6E7eTqWPLQ8YVL9v31f9NW56aeQBQAH-EJZK_ognw"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "1c1632e5f98cd7c948c86e90ca7bb984695e70d6dd81fe44d669d71878be3cc11db078cf72ec4cdb67e0fb7ef4730539554c91a559e666c821a6add33c785e01"
            }
          ]
        }
      } = ContCommand.build(cont_command)
    end

    test "with a keypair list", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "ugR6LZOPC36gSWWtyYTrozNWqMDFsuNyZQqV-UUEGzI"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "ffa2a279f4657428d579d7f60df4062bbbfc1c727470abb03078542c5b013bd97ffaaaf77873771be441b3a915ec6fbb7209b54aabe8f7dcb37681b0642d0e05"
            },
            %Signature{
              sig:
                "ffa2a279f4657428d579d7f60df4062bbbfc1c727470abb03078542c5b013bd97ffaaaf77873771be441b3a915ec6fbb7209b54aabe8f7dcb37681b0642d0e05"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypairs([keypair, keypair])
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with a signer in existing signer_list", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "NH1oRytubJHKE7I4W6UWsnfvF2NlehctV8H71o6_vfY"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "fa9924f206f6e95d3f3594ce954577d275e56d1bad23e348942ee261a93653c1186b4d02c88858d4103237041850548dd1469b002acc6bbd8cf6502fbdae3507"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with a SignersList", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      signers_list = SignersList.new([signer, signer])

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "NH1oRytubJHKE7I4W6UWsnfvF2NlehctV8H71o6_vfY"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "fa9924f206f6e95d3f3594ce954577d275e56d1bad23e348942ee261a93653c1186b4d02c88858d4103237041850548dd1469b002acc6bbd8cf6502fbdae3507"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signers(signers_list)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with a signers list", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      signers_list = [signer, signer]

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "NH1oRytubJHKE7I4W6UWsnfvF2NlehctV8H71o6_vfY"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "fa9924f206f6e95d3f3594ce954577d275e56d1bad23e348942ee261a93653c1186b4d02c88858d4103237041850548dd1469b002acc6bbd8cf6502fbdae3507"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signers(signers_list)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "without structs", %{
      pact_tx_hash: pact_tx_hash,
      raw_meta_data: raw_meta_data,
      keypair_data: keypair_data,
      signer: signer,
      nonce: nonce
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":\"valid proof\",\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "vb3u_BDS1Xu3ck7Okp6rK1LdLLwhixDEJBDNvr6AvAc"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "cbdd6e3d535967e0c964946e37a06b145c4fbe73d7a49f5af69f5e6bb3dddf51488a71f2791aed0b8283a265bdeef8a1e7f939e9998f9d370707efe5f1c8b808"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(raw_meta_data)
        |> ContCommand.add_keypair(keypair_data)
        |> ContCommand.add_signers([signer])
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_proof("valid proof")
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with an invalid data in build function", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [exec_command_request: :invalid_payload]} =
        ContCommand.new()
        |> ContCommand.set_data(8_947_289)
        |> ContCommand.set_network(:invalid)
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signers([signer])
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_proof(123)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with an invalid newtwork_id", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [network_id: :invalid, id: :invalid]} =
        ContCommand.new()
        |> ContCommand.set_network("invalid_value")
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid pact_tx_hash", %{
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [pact_tx_hash: :not_a_string]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(12)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid data", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [data: :invalid]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data("invalid_value")
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid step", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [step: :not_an_integer]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step("invalid_value")
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid rollback", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [rollback: :not_a_boolean]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback("invalid")
    end

    test "with an invalid proof", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [proof: :not_a_string]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_proof(999)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid nonce", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer
    } do
      {:error, [nonce: :not_a_string]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(:not_a_string)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_proof(nil)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid metadata", %{
      pact_tx_hash: pact_tx_hash,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      {:error, [meta_data: :invalid, args: :not_a_list]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata("invalid_value")
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid keypair", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      signer: signer,
      nonce: nonce
    } do
      {:error, [keypair: :invalid, args: :not_a_list]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair("invalid_value")
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid keypairs", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      signer: signer,
      nonce: nonce
    } do
      {:error, [keypairs: :not_a_list]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypairs("invalid_value")
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid keypairs list", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      signer: signer,
      nonce: nonce
    } do
      {:error, [keypair: :invalid, args: :not_a_list]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypairs(["invalid_value"])
        |> ContCommand.add_signer(signer)
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid signers", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      nonce: nonce
    } do
      {:error, [signers: :invalid, signers: :invalid_type]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signers("invalid_value")
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end

    test "with an invalid signer", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      nonce: nonce
    } do
      {:error, [signer: :invalid]} =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(%{})
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
        |> ContCommand.add_signer("invalid_value")
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
    end
  end
end
