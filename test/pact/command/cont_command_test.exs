defmodule Kadena.Pact.ContCommandTest do
  @moduledoc """
  `ContCommand` struct definition tests.
  """

  use ExUnit.Case
  alias Kadena.Cryptography.KeyPair, as: CryptographyKeyPair
  alias Kadena.Pact.ContCommand

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

  describe "create ContCommand" do
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
        metadata: MetaData.new(raw_meta_data),
        env_data: EnvData.new(env_data),
        keypair: KeyPair.new(keypair_data),
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "xATJH3mKRa41PaUy3FvFpfKbYgRKOaB0jR6hMt_vAt0"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "1995d72a21006786188d0780267646d525b63fb4da3aa5b7cb88c06e00f0a5048bb8c9728b31a91e51f10496deaa496a31643018593050a93969b86eb036be03"
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

    test "with a valid pipe creation, generating signers from keypairs", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      env_data: env_data,
      nonce: nonce
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{\"accounts_admin_keyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "frOJEOrvApvCBMFh3VwNqUfjqM5AjiOb5mTedmLe2KI"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "fb5b8797bfea462008feda3753a982c0e2c32a7049bd7ec7a8d0192dfedb89cda3c207cdd77cab0cbc2a2a463d491db4e3a72ca7219b398eab73e400c2d0fd04"
            }
          ]
        }
      } =
        ContCommand.new()
        |> ContCommand.set_network(:testnet04)
        |> ContCommand.set_data(env_data)
        |> ContCommand.set_nonce(nonce)
        |> ContCommand.set_metadata(metadata)
        |> ContCommand.add_keypair(keypair)
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":\"\",\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "Swlx9vlCCnHr7-fridqDCBgCWMgkRCGKeGH_bvky8sc"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "35b5d107676dade6f41a5a5df78bd828d77964f1409110977b16af1fe4182a3424b5502acbf6c3195c6796f9c4e78222eea980fda8758113976a7d154fcfe90c"
            }
          ]
        }
      } = ContCommand.build(cont_command)
    end

    test "with a valid new args and without data and proof", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      signer: signer,
      nonce: nonce
    } do
      cont_command =
        ContCommand.new(
          network_id: :testnet04,
          nonce: nonce,
          meta_data: metadata,
          keypairs: [keypair],
          signers: SignersList.new([signer]),
          pact_tx_hash: pact_tx_hash,
          step: 0,
          rollback: false
        )

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":null,\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "GsUyLbh-OnOdsn6UBo7BjFV4aO7T-XN2RfdftSafZUw"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "30d6d73445f05ed194d3246590cdaea0f2454fdc44a1d932c078f27ef460c8f06ecc91c06c08e22aa112556d4e0ed9a098d69425c1a9b90abf3f0a5eb9aa8203"
            }
          ]
        }
      } = ContCommand.build(cont_command)
    end

    test "with only requeried arguments", %{
      pact_tx_hash: pact_tx_hash
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"cont\":{\"data\":null,\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[]}",
        hash: %PactTransactionHash{
          hash: "7CsEAeE8YbvzE-QrE2X-6_EUPmodfZRQ4Xkd94kCPzg"
        },
        sigs: %SignaturesList{signatures: []}
      } =
        ContCommand.new()
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.build()
    end

    test "with signers and requeried arguments", %{
      pact_tx_hash: pact_tx_hash,
      signer: signer
    } do
      signers = SignersList.new([signer])

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"cont\":{\"data\":null,\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "HTo3Do2sJzJ9aV4bzrNlNzMwUBHCg6szy3f_mCPvMbQ"
        },
        sigs: %SignaturesList{signatures: []}
      } =
        ContCommand.new()
        |> ContCommand.set_pact_tx_hash(pact_tx_hash)
        |> ContCommand.set_step(0)
        |> ContCommand.set_rollback(false)
        |> ContCommand.add_signers(signers)
        |> ContCommand.build()
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "D6gtvsO0I7cF5so1WhfmD0ifB0bztQRKEo-PKSFOa20"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "09804662bf7e4de82df95b4c5357aed434ad23795b85196485581fb52590e60912e87c19083101491e1f5b9463fe0c3f0e556b052e4d4f313bf6d2bbb4ecb802"
            },
            %Signature{
              sig:
                "09804662bf7e4de82df95b4c5357aed434ad23795b85196485581fb52590e60912e87c19083101491e1f5b9463fe0c3f0e556b052e4d4f313bf6d2bbb4ecb802"
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "KTuk3PQm1KeFwPtpfHGNABkgPlhyTLVgbz9mFHLBDsU"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "c4b2d7c49b48fab72eaa66e2f4602d1d56da8feb336dcfbbfba4a939ace4a2f1cbf7631244aad8a27cacb67fbb0d600bd4c496ef92f56f31b0fe77b67efef101"
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"cont\":{\"data\":{},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":false,\"step\":0}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "hfqzSR0JGAYiOLnLw8Cw-KMAUL8GXjJTMNomw0a45e4"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "f0786c6f75ae7b43d3484b8d1aeaff7692a0d0a57ede11f08dfad58207d68810cf1883e61d1f439012c1ccadb359086552e0313bd95f8d1019c96fe0c53fd507"
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
        |> ContCommand.add_keypairs([keypair])
        |> ContCommand.add_signer(signer)
        |> ContCommand.add_signers(signer)
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
      {:error, [metadata: :invalid]} =
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
      {:error, [keypair: :invalid]} =
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

    test "with an invalid signers", %{
      pact_tx_hash: pact_tx_hash,
      metadata: metadata,
      keypair: keypair,
      nonce: nonce
    } do
      {:error, [signers: :invalid]} =
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
