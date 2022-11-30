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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "3BeOVboVQ9TwWAiQS65YHkgxOOiBQT5uMcQDm3vmNVA"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
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

    test "with a valid new args", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "3BeOVboVQ9TwWAiQS65YHkgxOOiBQT5uMcQDm3vmNVA"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "niwT670sdzjiBWlORejSHsaoVQHPfUiNkxtcVQfDysM"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "4a35b98eb50179c77784532ea7224d119f06c8a9853c421bd0cd3e667b54213840d01ee926ab19a02d0777f68297b88bbc5799bcd281ed0e9c2c7993dab7740b"
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

    test "with a valid keyword list in meta_data", %{
      raw_meta_data: raw_meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "3BeOVboVQ9TwWAiQS65YHkgxOOiBQT5uMcQDm3vmNVA"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
            }
          ]
        }
      } =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(raw_meta_data)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.build()
    end

    test "with a valid keyword list in keypair", %{
      meta_data: meta_data,
      keypair_data: keypair_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "3BeOVboVQ9TwWAiQS65YHkgxOOiBQT5uMcQDm3vmNVA"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
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
        |> ExecCommand.add_keypair(keypair_data)
        |> ExecCommand.add_signer(signer)
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "3BeOVboVQ9TwWAiQS65YHkgxOOiBQT5uMcQDm3vmNVA"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
            },
            %Signature{
              sig:
                "e4ea07728a52b564156ea44aa2817931b56829eaa361f1b5c4f2a419acaa5c9c77e4e29ac55f5d250d27d066dc8b4f1076fdc5d402fa4cbffe2f63dc36e1e705"
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
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "niwT670sdzjiBWlORejSHsaoVQHPfUiNkxtcVQfDysM"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "4a35b98eb50179c77784532ea7224d119f06c8a9853c421bd0cd3e667b54213840d01ee926ab19a02d0777f68297b88bbc5799bcd281ed0e9c2c7993dab7740b"
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

    test "with a signers list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      signers_list = [signer, signer]

      %Command{
        cmd:
          "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
        hash: %PactTransactionHash{
          hash: "niwT670sdzjiBWlORejSHsaoVQHPfUiNkxtcVQfDysM"
        },
        sigs: %SignaturesList{
          signatures: [
            %Signature{
              sig:
                "4a35b98eb50179c77784532ea7224d119f06c8a9853c421bd0cd3e667b54213840d01ee926ab19a02d0777f68297b88bbc5799bcd281ed0e9c2c7993dab7740b"
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
        |> ExecCommand.add_signers([signer])
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
        |> ExecCommand.add_signers([signer])
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
        |> ExecCommand.add_signers([signer])
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
        |> ExecCommand.add_signers([signer])
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
        |> ExecCommand.add_signers([signer])
    end

    test "with an invalid meta_data", %{
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [meta_data: :invalid, args: :not_a_list]} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata("invalid value")
        |> ExecCommand.add_keypairs([keypair])
        |> ExecCommand.add_signers([signer])
    end

    test "with an invalid keypair", %{
      meta_data: meta_data,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:error, [keypair: :invalid, args: :not_a_list]} =
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
      {:error, [keypair: :invalid, args: :not_a_list]} =
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
      {:error, [signers: :invalid, signers: :invalid_type]} =
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
