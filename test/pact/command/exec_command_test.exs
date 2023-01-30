defmodule Kadena.Pact.ExecCommandTest do
  @moduledoc """
  `ExecCommand` struct definition tests.
  """
  use ExUnit.Case

  alias Kadena.Cryptography.KeyPair, as: CryptographyKeyPair
  alias Kadena.Pact.ExecCommand

  alias Kadena.Types.{
    Cap,
    Command,
    EnvData,
    KeyPair,
    MetaData,
    PactTransactionHash,
    Signature,
    Signer
  }

  describe "create ExecCommand with YAMl file" do
    setup do
      path = "test/support/yaml_tests_files/for_test_exec.yaml"
      path2 = "test/support/yaml_tests_files/for_test_commands_1.yaml"
      path3 = "test/support/yaml_tests_files/for_test_commands_2.yaml"
      path4 = "test/support/yaml_tests_files/for_test_commands_3.yaml"
      path5 = "test/support/yaml_tests_files/for_test_commands_4.yaml"
      path6 = "test/support/yaml_tests_files/for_test_commands_5.yaml"
      path7 = "test/support/yaml_tests_files/for_test_commands_6.yaml"
      path8 = "test/support/yaml_tests_files/for_test_commands_7.yaml"
      bad_path = "test/support/yaml_tests_files/no_existent.yaml"

      %{
        path: path,
        path2: path2,
        path3: path3,
        path4: path4,
        path5: path5,
        path6: path6,
        path7: path7,
        path8: path8,
        bad_path: bad_path
      }
    end

    test "with a valid YAML file", %{path: path} do
      {:ok,
       %Kadena.Types.Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{\"accounts-admin-keyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]}}},\"signers\":[{\"addr\":null,\"clist\":[],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":\"cc30ae980161eba5da95a0d27dbdef29f185a23406942059c16cb120f6dc9dea\",\"clist\":[{\"args\":[\"8693e641ae2bbe9ea802c736f42027b03f86afe63cae315e7169c9c496c17332\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"cc30ae980161eba5da95a0d27dbdef29f185a23406942059c16cb120f6dc9dea\",\"scheme\":\"ED25519\"}]}",
         hash: %Kadena.Types.PactTransactionHash{
           hash: "S7nmnln18fwy7_sASguWoJXw3_2svm6TWmSMQ3alCv8"
         },
         sigs: [
           %Kadena.Types.Signature{
             sig:
               "d0435fba35fcb57f04810d932d942de81001ba16992977bbf14761a7f5c676a2f2b91a2ab6c04b9bd509ec3392668485ae1b53ea1f1882843c12dea777636d02"
           }
         ]
       }} =
        path
        |> ExecCommand.from_yaml()
        |> ExecCommand.build()
    end

    test "without metadata, signers and keypairs", %{path2: path2} do
      {:ok,
       %Kadena.Types.Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":\"testnet04\",\"nonce\":\"step01\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{\"accounts-admin-keyset\":[\"ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d\"]}}},\"signers\":[]}",
         hash: %Kadena.Types.PactTransactionHash{
           hash: "5PF8EzDCdBLiW6lSzQWi9asTYvxx6ehc3cwJ-O4O5HY"
         },
         sigs: []
       }} =
        path2
        |> ExecCommand.from_yaml()
        |> ExecCommand.build()
    end

    test "with an invalid path" do
      {:error, [path: :invalid]} = ExecCommand.from_yaml(123)
    end

    test "with a non existing YAML file", %{bad_path: bad_path} do
      {:error,
       %YamlElixir.FileNotFoundError{
         message:
           "Failed to open file \"test/support/yaml_tests_files/no_existent.yaml\": no such file or directory"
       }} = ExecCommand.from_yaml(bad_path)
    end

    test "with an invalid meta_data", %{path3: path3} do
      {:error, [metadata: :invalid]} = ExecCommand.from_yaml(path3)
    end

    test "with an invalid meta_data args", %{path4: path4} do
      {:error, [meta_data: :invalid, gas_price: :invalid]} = ExecCommand.from_yaml(path4)
    end

    test "with an invalid keypair", %{path5: path5} do
      {:error, [keypair: :invalid]} = ExecCommand.from_yaml(path5)
    end

    test "with an invalid keypair args", %{path6: path6} do
      {:error, [keypair: :invalid, pub_key: :invalid]} = ExecCommand.from_yaml(path6)
    end

    test "with an invalid signers", %{path7: path7} do
      {:error, [signers: :invalid]} = ExecCommand.from_yaml(path7)
    end

    test "with an invalid signers args", %{path8: path8} do
      {:error, [signers: :invalid, scheme: :invalid]} = ExecCommand.from_yaml(path8)
    end
  end

  describe "create ExecCommand" do
    setup do
      secret_key = "99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4"
      {:ok, %KeyPair{pub_key: pub_key}} = CryptographyKeyPair.from_secret_key(secret_key)
      cap = Cap.new(name: "coin.GAS", args: [pub_key])
      clist = [cap]

      keypair_data = [pub_key: pub_key, secret_key: secret_key, clist: clist]

      {:ok, %KeyPair{pub_key: pub_key2} = keypair2} =
        CryptographyKeyPair.from_secret_key(
          "0b59981d29c3606ac5198278795c073f501d36c8b2c14969cd30d7de2b0d62a9"
        )

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
        keypair2: keypair2,
        signer:
          Signer.new(
            pub_key: pub_key,
            scheme: :ed25519,
            addr: pub_key,
            clist: clist
          ),
        signer2:
          Signer.new(
            pub_key: pub_key2,
            scheme: :ed25519
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
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "2lnN17Ev5LuLUQXQ8fXNWf_Z7R0x3lrFejZ-yZMKWww"
         },
         sigs: [
           %Signature{
             sig:
               "a4ac51052152ccff62e8dfdafe9e17df999e5b2b9cacccf2707a39a878bde0b9e18f7eff792b8863b9e9a329289f5de8eb86a8f5ff8fed399cd4258ac75b7907"
           }
         ]
       }} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.build()
    end

    test "with a valid pipe creation, generating signers from keypairs", %{
      meta_data: meta_data,
      keypair: keypair,
      nonce: nonce,
      code: code,
      env_data: env_data
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{\"accounts_admin_keyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]}}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %Kadena.Types.PactTransactionHash{
           hash: "jXp99H0iuZBXQUCCihWSqULfwKpexB9dEKozviN4QPM"
         },
         sigs: [
           %Signature{
             sig:
               "36d55e69103b266e53521b2d8d7ca1a0055b7d178970511f8319a6029315e1bf6a518c24a94f2ba20e041f7ec69e7c503a14c1c886f54d51e65674a377a5fb06"
           }
         ]
       }} =
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
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "2lnN17Ev5LuLUQXQ8fXNWf_Z7R0x3lrFejZ-yZMKWww"
         },
         sigs: [
           %Signature{
             sig:
               "a4ac51052152ccff62e8dfdafe9e17df999e5b2b9cacccf2707a39a878bde0b9e18f7eff792b8863b9e9a329289f5de8eb86a8f5ff8fed399cd4258ac75b7907"
           }
         ]
       }} =
        ExecCommand.new(
          network_id: :testnet04,
          data: %{},
          code: code,
          nonce: nonce,
          meta_data: meta_data,
          keypairs: [keypair],
          signers: [signer]
        )
        |> ExecCommand.build()
    end

    test "with a valid new args and without data", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "Kk-dF78h0kaw8Ku5v-Ts4cLyvoDBYyROQVEm240Fx9Q"
         },
         sigs: [
           %Signature{
             sig:
               "0be960f6fd0e5687c2caf9ece1a6f544de2fb9fccb0850d1693e261ed8e500d3f5012231658335cb3b08d6eead1bcbe98e11b7afbc3b75999e9e0c77b29a930e"
           }
         ]
       }} =
        ExecCommand.new(
          network_id: :testnet04,
          code: code,
          nonce: nonce,
          meta_data: meta_data,
          keypairs: [keypair],
          signers: [signer]
        )
        |> ExecCommand.build()
    end

    test "with a signer in existing signer_list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      signer2: signer2,
      nonce: nonce,
      code: code
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[],\"pubKey\":\"cc30ae980161eba5da95a0d27dbdef29f185a23406942059c16cb120f6dc9dea\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "tXmmohuUXUt6Uzx3L3okK-yY2x_OEIN_ZujgS7d3174"
         },
         sigs: [
           %Signature{
             sig:
               "fd18fd8e02806ad0a861740595f0a68338cd34fe81a2bf7270d7007b009b7033606e4ec95ba465fc19f1ef94d94ff0291c23d6eec1170e437eed84710144de0e"
           }
         ]
       }} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.add_signer(signer2)
        |> ExecCommand.build()
    end

    test "with only code", %{
      code: code
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[]}",
         hash: %PactTransactionHash{
           hash: "UKgNDSO6gc78eUwZf2PHLIfG4mHHth0ol52n4JtjwS0"
         },
         sigs: []
       }} =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.build()
    end

    test "with keypair and without signers", %{
      code: code,
      keypair: keypair
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "4HznR8QoUaRavOcEm9FbjO7JX7ID_LNhV5NCegYJLHQ"
         },
         sigs: [
           %Signature{
             sig:
               "77a0c4964ebc983a049082086f2d1fcccce32d4e72d9bdc377e21ef4dbec202813a6088ec683a13617ab723038bc4be7a122e37274b3a6f82ecc1e5a003a930f"
           }
         ]
       }} =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.add_keypair(keypair)
        |> ExecCommand.build()
    end

    test "with only code and signers", %{
      code: code,
      signer: signer
    } do
      signers = [signer]

      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":0,\"gasLimit\":0,\"gasPrice\":0,\"sender\":\"\",\"ttl\":0},\"networkId\":null,\"nonce\":\"\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":null}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "FSel8P9Mb4NhBE6eamiF_jHtQUycrKtGjeJOVL_sQV4"
         },
         sigs: []
       }} =
        ExecCommand.new()
        |> ExecCommand.set_code(code)
        |> ExecCommand.add_signers(signers)
        |> ExecCommand.build()
    end

    test "with a keypair list", %{
      meta_data: meta_data,
      keypair: keypair,
      keypair2: keypair2,
      signer: signer,
      nonce: nonce,
      code: code
    } do
      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[],\"pubKey\":\"cc30ae980161eba5da95a0d27dbdef29f185a23406942059c16cb120f6dc9dea\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "tXmmohuUXUt6Uzx3L3okK-yY2x_OEIN_ZujgS7d3174"
         },
         sigs: [
           %Signature{
             sig:
               "fd18fd8e02806ad0a861740595f0a68338cd34fe81a2bf7270d7007b009b7033606e4ec95ba465fc19f1ef94d94ff0291c23d6eec1170e437eed84710144de0e"
           },
           %Signature{
             sig:
               "6e3735ef0f96a566076733db78c0bf303de3bcfe19f5a8b8067ffd1d0e1fb60cfb2166fe6e3e363d87cdd02f98427826298ca64f652554977c13e1819d6a8c0a"
           }
         ]
       }} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_signer(signer)
        |> ExecCommand.add_keypairs([keypair, keypair2])
        |> ExecCommand.build()
    end

    test "with a Signer list", %{
      meta_data: meta_data,
      keypair: keypair,
      signer: signer,
      signer2: signer2,
      nonce: nonce,
      code: code
    } do
      signers_list = [signer, signer2]

      {:ok,
       %Command{
         cmd:
           "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":1000,\"gasPrice\":1.0e-6,\"sender\":\"k:554754f48b16df24b552f6832dda090642ed9658559fef9f3ee1bb4637ea7c94\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-06-13 17:45:18.211131 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 5 6)\",\"data\":{}}},\"signers\":[{\"addr\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[],\"pubKey\":\"cc30ae980161eba5da95a0d27dbdef29f185a23406942059c16cb120f6dc9dea\",\"scheme\":\"ED25519\"},{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
         hash: %PactTransactionHash{
           hash: "ZhEB5Kn8vjHrtoB3c7XGg97feEuDxisgNIx1SmhNg4Q"
         },
         sigs: [
           %Signature{
             sig:
               "7f699bc02dd67cbd390e7b29a25c2c98c50cd6cbe2b6883b457943a64c2d5cbb812cbab9d9c168d372ba803a67816e5de71ee869723e9a43a9065e7e6ea9a603"
           }
         ]
       }} =
        ExecCommand.new()
        |> ExecCommand.set_network(:testnet04)
        |> ExecCommand.set_data(%{})
        |> ExecCommand.set_code(code)
        |> ExecCommand.set_nonce(nonce)
        |> ExecCommand.set_metadata(meta_data)
        |> ExecCommand.add_signers(signers_list)
        |> ExecCommand.add_keypair(keypair)
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
      {:error, [signers: :not_a_signer_list]} =
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
