# Kadena.ex

![Stability Badge](https://img.shields.io/badge/stability-alpha-f4d03f.svg?style=for-the-badge)
![Build Badge](https://img.shields.io/github/actions/workflow/status/kommitters/kadena.ex/ci.yml?branch=main&style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/kadena.ex?style=for-the-badge)](https://coveralls.io/github/kommitters/kadena.ex)
[![Version Badge](https://img.shields.io/hexpm/v/kadena?style=for-the-badge)](https://hexdocs.pm/kadena)
![Downloads Badge](https://img.shields.io/hexpm/dt/kadena?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/kadena?style=for-the-badge)](https://github.com/kommitters/kadena.ex/blob/main/LICENSE)
[![OpenSSF Best Practices](https://img.shields.io/cii/summary/6474?label=openssf%20best%20practices&style=for-the-badge)](https://bestpractices.coreinfrastructure.org/projects/6474)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/kommitters/kadena.ex?label=openssf%20scorecard&style=for-the-badge)](https://api.securityscorecards.dev/projects/github.com/kommitters/kadena.ex)

**Kadena.ex** is an open source library for Elixir that allows developers to interact with Kadena Chainweb.

## What can you do with Kadena.ex?

- Build PACT commands for transactions.
- Implement the cryptography required by the network.
- Send, test and update smart contracts.
- Interact with Chainweb endpoints: `listen, local, poll, send, spv.`

## Installation

Add `kadena` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kadena, "~> 0.11.1"}
  ]
end
```

## Configuration

The default HTTP Client is `:hackney`. Options can be passed to `:hackney` via configuration parameters.
```elixir
config :kadena, hackney_opts: [{:connect_timeout, 1000}, {:recv_timeout, 5000}]
```

### Custom HTTP Client
`kadena.ex` allows you to use the HTTP client of your choice. See [**Kadena.Chainweb.Client.Spec**][http_client_spec] for details.

```elixir
config :kadena, :http_client_impl, YourApp.CustomClientImpl
```

### Custom JSON library
Following the same approach as the HTTP client, the JSON parsing library can also be configured. Defaults to [`Jason`][jason_url].

```elixir
config :kadena, :json_library, YourApp.CustomJSONLibrary
```

## Keypairs
Curve25519 keypair of (PUBLIC,SECRET) match. Key values are base-16 strings of length 32.

### Generate a KeyPair

```elixir
alias Kadena.Cryptography.KeyPair

# generate a random keypair
{:ok, keypair} = KeyPair.generate()

{:ok,
 %Kadena.Types.KeyPair{
   clist: nil,
   pub_key: "37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9",
   secret_key: "e53faf1774d30e7cec2878d2e4a617c34045f53f0579eb05e127a7808aac229d"
 }}
```

### Derive a keyPair from a secret key
```elixir
{:ok, keypair} = KeyPair.from_secret_key("e53faf1774d30e7cec2878d2e4a617c34045f53f0579eb05e127a7808aac229d")

{:ok,
 %Kadena.Types.KeyPair{
   clist: nil,
   pub_key: "37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9",
   secret_key: "e53faf1774d30e7cec2878d2e4a617c34045f53f0579eb05e127a7808aac229d"
 }}
```

### Adding capabilities to a KeyPair

```elixir
alias Kadena.Cryptography.KeyPair
alias Kadena.Types.Cap

{:ok, keypair} = KeyPair.from_secret_key("e53faf1774d30e7cec2878d2e4a617c34045f53f0579eb05e127a7808aac229d")

clist = [
  Cap.new(name: "coin.GAS", args: [keypair.pub_key])
]

keypair_with_caps = Kadena.Types.KeyPair.add_caps(keypair, clist)

%Kadena.Types.KeyPair{
  clist: [
    %Kadena.Types.Cap{
      args: [
        %Kadena.Types.PactValue{
          literal: "37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9"
        }
      ],
      name: "coin.GAS"
    }
  ],
  pub_key: "37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9",
  secret_key: "e53faf1774d30e7cec2878d2e4a617c34045f53f0579eb05e127a7808aac229d"
}
```

## PACT Commands

`kadena.ex` allows the construction of **execution** and **continuation** commands in a semantic way for developers.

```elixir
alias Kadena.Cryptography.KeyPair
alias Kadena.Types.Command
alias Kadena.Pact

{:ok, keypair} = KeyPair.generate()

code = "(+ 1 2)"

{:ok, %Command{} = command} =
  Pact.ExecCommand.new()
  |> Pact.ExecCommand.set_code(code)
  |> Pact.ExecCommand.add_keypair(keypair)
  |> Pact.ExecCommand.build()
```

### Attributes

#### NetworkID
Backend-specific identifier of target network. Allowed values: `:testnet04` `:mainnet01` `:development`.

```elixir
alias Kadena.Pact

network_id = :testnet04

Pact.ExecCommand.new() |> Pact.ExecCommand.set_network(network_id)
```

#### Code
Executable PACT code.

```elixir
alias Kadena.Pact

code = "(+ 1 2)"

Pact.ExecCommand.new() |> Pact.ExecCommand.set_code(code)
```

#### Metadata
Public metadata for Chainweb.

```elixir
alias Kadena.Pact

metadata = Kadena.Types.MetaData.new(
    creation_time: 1_667_249_173,
    ttl: 28_800,
    gas_limit: 1000,
    gas_price: 0.01,
    sender: "k:37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9",
    chain_id: "0"
  )

Pact.ExecCommand.new() |> Pact.ExecCommand.set_metadata(metadata)
```

#### Nonce
An arbitrary user-supplied value. Defaults to current timestamp.

```elixir
alias Kadena.Pact

nonce = "2023-01-01 00:00:00.000000 UTC"

Pact.ExecCommand.new() |> Pact.ExecCommand.set_nonce(data)
```

#### EnvData
Environment transaction data.

```elixir
alias Kadena.Pact

env_data = %{
    accounts_admin_keyset: [
      "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
    ]
  }

Pact.ExecCommand.new() |> Pact.ExecCommand.set_data(data)
```

#### KeyPairs
List of KeyPairs for signing.

```elixir
alias Kadena.Pact
alias Kadena.Cryptography.KeyPair

{:ok, keypair1} = KeyPair.generate()
{:ok, keypair2} = KeyPair.generate()

# add a list of keypairs
Pact.ExecCommand.new() |> Pact.ExecCommand.add_keypairs([keypair1, keypair2])

# add a single keypair
Pact.ExecCommand.new() |> Pact.ExecCommand.add_keypair(keypair1)
```

#### Signers
List of signers for detached signatures.

```elixir
alias Kadena.Pact

signer1 = Kadena.Types.Signer.new(pub_key: "37e60c00779cacaef1f0a8697387a5945ef3cb82963980db486dc26ec5f424d9")
signer2 = Kadena.Types.Signer.new(pub_key: "8567032f1fe8b99c657338cd46480d0ee1a86985626b16374099d8d406e4d313")

# add a list of signers
Pact.ExecCommand.new() |> Pact.ExecCommand.add_signers([signer1, signer2])

# add a single signer
Pact.ExecCommand.new() |> Pact.ExecCommand.add_signer(signer1)
```

#### Step (Continuation command)

An integer value for the multi-step transaction.

```elixir
alias Kadena.Pact

step = 1

Pact.ContCommand.new() |> Pact.ContCommand.set_step(step)
```

#### Proof (Continuation command)

A SPV proof, required for cross-chain transfer.

```elixir
alias Kadena.Pact

proof = "proof"

Pact.ContCommand.new() |> Pact.ContCommand.set_proof(proof)
```

#### Rollback (Continuation command)

A Boolean that indicates if the continuation is:

- rollback `true`
- cancel `false`

```elixir
alias Kadena.Pact

rollback = true

Pact.ContCommand.new() |> Pact.ContCommand.set_rollback(rollback)
```

#### PactTxHash (Continuation command)

Continuation transaction hash.

```elixir
alias Kadena.Pact

pact_tx_hash = "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"

Pact.ContCommand.new() |> Pact.ContCommand.set_pact_tx_hash(pact_tx_hash)
```

### Building an Execution Command

```elixir
alias Kadena.Cryptography
alias Kadena.Pact

# set the command attributes
{:ok, raw_keypair} = Cryptography.KeyPair.from_secret_key("99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4")

caps = [
  Kadena.Types.Cap.new(name: "coin.GAS", args: [raw_keypair.pub_key])
]


keypair = Kadena.Types.KeyPair.add_caps(raw_keypair, caps)

network_id = :testnet04

code = "(+ 1 2)"

metadata = Kadena.Types.MetaData.new(
    creation_time: 1_667_249_173,
    ttl: 28_800,
    gas_limit: 2500,
    gas_price: 0.01,
    sender: "k:#{keypair.pub_key}",
    chain_id: "0"
  )

nonce = "2023-01-01 00:00:00.000000 UTC"

env_data = %{accounts_admin_keyset: [keypair.pub_key]}

# build the command
{:ok, %Kadena.Types.Command{} = command} =
  Pact.ExecCommand.new()
  |> Pact.ExecCommand.set_network(network_id)
  |> Pact.ExecCommand.set_code(code)
  |> Pact.ExecCommand.set_nonce(nonce)
  |> Pact.ExecCommand.set_data(env_data)
  |> Pact.ExecCommand.set_metadata(metadata)
  |> Pact.ExecCommand.add_keypair(keypair)
  |> Pact.ExecCommand.build()

{:ok,
 %Kadena.Types.Command{
   cmd:
     "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":2500,\"gasPrice\":0.01,\"sender\":\"k:6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-01-01 00:00:00.000000 UTC\",\"payload\":{\"exec\":{\"code\":\"(+ 1 2)\",\"data\":{\"accounts_admin_keyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]}}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
   hash: %Kadena.Types.PactTransactionHash{
     hash: "ZOsqP9Wkfj5NnY9WS_XMnO9KfYv0GvK_8QMPTX6BfaA"
   },
   sigs: [
     %Kadena.Types.Signature{
       sig:
         "5b0635c2376949103d8ce8243a1fd34a1a8964900d69eebb1ff4d38ffde437a317f887f864fa9c1b27a97e8d9e57eef8dd58b054edf30b4e6fe89d0208290f02"
     }
   ]
 }}
```

### Building a Continuation Command

```elixir
alias Kadena.Cryptography
alias Kadena.Pact

# set the command attributes
{:ok, raw_keypair} = Cryptography.KeyPair.from_secret_key("99f7e1e8f2f334ae8374aa28bebdb997271a0e0a5e92c80be9609684a3d6f0d4")

caps = [
  Kadena.Types.Cap.new(name: "coin.GAS", args: [raw_keypair.pub_key])
]

keypair = Kadena.Types.KeyPair.add_caps(raw_keypair, caps)

network_id = :testnet04

metadata = Kadena.Types.MetaData.new(
    creation_time: 1_667_249_173,
    ttl: 28_800,
    gas_limit: 2500,
    gas_price: 0.01,
    sender: "k:#{keypair.pub_key}",
    chain_id: "0"
  )

nonce = "2023-01-01 00:00:00.000000 UTC"

env_data = %{accounts_admin_keyset: [keypair.pub_key]}

pact_tx_hash = "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"

step = 1

rollback = true

# build the command
{:ok, %Kadena.Types.Command{} = command} =
  Pact.ContCommand.new()
  |> Pact.ContCommand.set_network(network_id)
  |> Pact.ContCommand.set_data(env_data)
  |> Pact.ContCommand.set_nonce(nonce)
  |> Pact.ContCommand.set_metadata(metadata)
  |> Pact.ContCommand.add_keypair(keypair)
  |> Pact.ContCommand.set_pact_tx_hash(pact_tx_hash)
  |> Pact.ContCommand.set_step(step)
  |> Pact.ContCommand.set_rollback(rollback)
  |> Pact.ContCommand.build()

{:ok,
 %Kadena.Types.Command{
   cmd:
     "{\"meta\":{\"chainId\":\"0\",\"creationTime\":1667249173,\"gasLimit\":2500,\"gasPrice\":0.01,\"sender\":\"k:6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"ttl\":28800},\"networkId\":\"testnet04\",\"nonce\":\"2023-01-01 00:00:00.000000 UTC\",\"payload\":{\"cont\":{\"data\":{\"accounts_admin_keyset\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"]},\"pactId\":\"yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4\",\"proof\":null,\"rollback\":true,\"step\":1}},\"signers\":[{\"addr\":null,\"clist\":[{\"args\":[\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\"],\"name\":\"coin.GAS\"}],\"pubKey\":\"6ffea3fabe4e7fe6a89f88fc6d662c764ed1359fbc03a28afdac3935415347d7\",\"scheme\":\"ED25519\"}]}",
   hash: %Kadena.Types.PactTransactionHash{
     hash: "DIMUpcB9NahL3746TTm1A8Wrr-JRVCT5Rk0rPdxZItg"
   },
   sigs: [
     %Kadena.Types.Signature{
       sig:
         "98de12eda675334c7fddb6ca453017bf2df5af928c2c0763f8748b950f81b7b075f74fc2294f6a16099aa51955a035889767f048a76f7a272eaf639140dbd20a"
     }
   ]
 }}
```

## Chainweb Pact API

Interaction with [Chainweb Pact API][chainweb_pact_api_doc] is done through the [**Kadena.Chainweb.Pact**][chainweb_pact_api] module using simple functions to access endpoints.

### Send endpoint

Retrieves the request keys of the Pact transactions sent to the network.

```elixir
Kadena.Chainweb.Pact.send(cmds, network_opts \\ [network_id: :testnet04, chain_id: 0])
```

**Parameters**

- `cmds`: List of [PACT commands](#pact-commands).
- `network_opts`: Network options. Keyword list with:
  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `chain_id` (required): Allowed values: integer or string-encoded integer from 0 to 19.

  Defaults to `[network_id: :testnet04, chain_id: 0]` if not specified.

**Example**

```elixir
alias Kadena.Chainweb
alias Kadena.Cryptography
alias Kadena.Pact

{:ok, keypair} =
  Cryptography.KeyPair.from_secret_key(
    "28834b7a0d6d1f84ae2c2efcb5b1de28122e07e2e4caad04a32988a3c79c547c"
  )

network_id = :testnet04

metadata =
  Kadena.Types.MetaData.new(
    creation_time: 1_671_462_208,
    ttl: 28_800,
    gas_limit: 1000,
    gas_price: 0.000001,
    sender: "k:#{keypair.pub_key}",
    chain_id: "1"
  )

code = "(+ 1 2)"

{:ok, cmd1} =
  Pact.ExecCommand.new()
  |> Pact.ExecCommand.set_network(network_id)
  |> Pact.ExecCommand.set_code(code)
  |> Pact.ExecCommand.set_metadata(metadata)
  |> Pact.ExecCommand.add_keypair(keypair)
  |> Pact.ExecCommand.build()

code = "(+ 2 2)"

{:ok, cmd2} =
  Pact.ExecCommand.new()
  |> Pact.ExecCommand.set_network(network_id)
  |> Pact.ExecCommand.set_code(code)
  |> Pact.ExecCommand.set_metadata(metadata)
  |> Pact.ExecCommand.add_keypair(keypair)
  |> Pact.ExecCommand.build()

cmds = [cmd1, cmd2]

Chainweb.Pact.send(cmds, network_id: :testnet04, chain_id: 1)

{:ok,
 %Kadena.Chainweb.Pact.SendResponse{
   request_keys: [
     "rz03l9cXJTLNzBJoTitum7yyBq3amdAqM5sopw5gZyQ",
     "dS3UDAnJBKwReOFiyNU6qUwuclvXKDMYSPT6YDCkrJY"
   ]
 }}
```

### Local endpoint

Executes a single command on the local server and retrieves the transaction result. Useful with code that queries from blockchain. It does not impact the blockchain when returning transaction results.

```elixir
Kadena.Chainweb.Pact.local(cmd, network_opts \\ [network_id: :testnet04, chain_id: 0])
```

**Parameters**

- `cmd`: [PACT command](#pact-commands).
- `network_opts`: Network options. Keyword list with:

  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `chain_id` (required): Allowed values: integer or string-encoded integer from 0 to 19.

  Defaults to `[network_id: :testnet04, chain_id: 0]` if not specified.

**Example**

```elixir
alias Kadena.Chainweb
alias Kadena.Cryptography
alias Kadena.Pact

{:ok, keypair} =
  Cryptography.KeyPair.from_secret_key(
    "28834b7a0d6d1f84ae2c2efcb5b1de28122e07e2e4caad04a32988a3c79c547c"
  )

metadata =
  Kadena.Types.MetaData.new(
    creation_time: 1_671_462_208,
    ttl: 28_800,
    gas_limit: 1000,
    gas_price: 0.000001,
    sender: "k:#{keypair.pub_key}",
    chain_id: "1"
  )

code = "(+ 1 2)"

{:ok, cmd} =
  Pact.ExecCommand.new()
  |> Pact.ExecCommand.set_code(code)
  |> Pact.ExecCommand.set_metadata(metadata)
  |> Pact.ExecCommand.add_keypair(keypair)
  |> Pact.ExecCommand.build()

Chainweb.Pact.local(cmd, network_id: :testnet04, chain_id: 1)

{:ok,
 %Kadena.Chainweb.Pact.LocalResponse{
   continuation: nil,
   events: nil,
   gas: 5,
   logs: "wsATyGqckuIvlm89hhd2j4t6RMkCrcwJe_oeCYr7Th8",
   meta_data: %{
     block_height: 2_833_149,
     block_time: 1_671_577_178_603_103,
     prev_block_hash: "7aURwajZ0pBMGEKmOUJ9oLq9MK7QiZeiDPGPb0cXs5c",
     public_meta: %{
       chain_id: "1",
       creation_time: 1_671_462_208,
       gas_limit: 1000,
       gas_price: 1.0e-6,
       sender: "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
       ttl: 28800
     }
   },
   req_key: "8qnotzzhbfe_SSmZcDVQGDpALjQjYqzYYrHc6D-2D_g",
   result: %{data: 3, status: "success"},
   tx_id: nil
 }}
```
### Poll endpoint

Retrieves one or more transaction results per request key.

```elixir
Kadena.Chainweb.Pact.poll(request_keys, network_opts \\ [network_id: :testnet04, chain_id: 0])
```

**Parameters**

- `request_keys`: List of strings. A request key is the unique id of a Pact transaction consisting of its hash, it is obtained from submitting a command via the  [Send endpoint](#send-endpoint).
- `network_opts`: Network options. Keyword list with:

  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `chain_id` (required): Allowed values: integer or string-encoded integer from 0 to 19.

  Defaults to `[network_id: :testnet04, chain_id: 0]` if not specified.

**Example**

```elixir
alias Kadena.Chainweb

request_keys = [
  "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc",
  "gyShUgtFBk5xDoiBoLURbU_5vUG0benKroNDRhz8wqA"
]

Chainweb.Pact.poll(request_keys, network_id: :testnet04, chain_id: 1)

{:ok,
 %Kadena.Chainweb.Pact.PollResponse{
   results: [
     %Kadena.Chainweb.Pact.CommandResult{
       continuation: nil,
       events: [
         %{
           module: %{name: "coin", namespace: nil},
           module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
           name: "TRANSFER",
           params: [
             "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
             "k:db776793be0fcf8e76c75bdb35a36e67f298111dc6145c66693b0133192e2616",
             2.33e-4
           ]
         }
       ],
       gas: 233,
       logs: "3I4ueiuyFy2m_z6PHpOe9yqXIt9tfDjMoUlPnqg_jas",
       meta_data: %{
         block_hash: "Z9fszmqYV7s_rLyvvdAw5nbLqdMIj-_P4lPGFMLRy3M",
         block_height: 2_829_780,
         block_time: 1_671_476_220_495_690,
         prev_block_hash: "9LKeJBo1REDwbVUYjxKKvbuHN4kFRDmjxEqatUUPu8g"
       },
       req_key: "gyShUgtFBk5xDoiBoLURbU_5vUG0benKroNDRhz8wqA",
       result: %{data: 4, status: "success"},
       tx_id: 4_272_497
     },
     %Kadena.Chainweb.Pact.CommandResult{
       continuation: nil,
       events: [
         %{
           module: %{name: "coin", namespace: nil},
           module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
           name: "TRANSFER",
           params: [
             "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
             "k:db776793be0fcf8e76c75bdb35a36e67f298111dc6145c66693b0133192e2616",
             2.33e-4
           ]
         }
       ],
       gas: 233,
       logs: "P3CDVUbCSSsXukPztkmLjJL7tsxNNIuPHKyhGMD_0wE",
       meta_data: %{
         block_hash: "Z9fszmqYV7s_rLyvvdAw5nbLqdMIj-_P4lPGFMLRy3M",
         block_height: 2_829_780,
         block_time: 1_671_476_220_495_690,
         prev_block_hash: "9LKeJBo1REDwbVUYjxKKvbuHN4kFRDmjxEqatUUPu8g"
       },
       req_key: "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc",
       result: %{data: 3, status: "success"},
       tx_id: 4_272_500
     }
   ]
 }}
```

### Listen endpoint

Retrieves the transaction result of the given request key.

```elixir
Kadena.Chainweb.Pact.listen(request_key, network_opts \\ [network_id: :testnet04, chain_id: 0])
```

**Parameters**

- `request_key`: String value. A request key is the unique id of a Pact transaction consisting of its hash, it is obtained from submitting a command via the [Send endpoint](#send-endpoint).
- `network_opts`: Network options. Keyword list with:

  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `chain_id` (required): Allowed values: integer or string-encoded integer from 0 to 19.

  Defaults to `[network_id: :testnet04, chain_id: 0]` if not specified.

**Example**

```elixir
alias Kadena.Chainweb

request_key = "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc"

Chainweb.Pact.listen(request_key, network_id: :testnet04, chain_id: 1)

{:ok,
 %Kadena.Chainweb.Pact.ListenResponse{
   continuation: nil,
   events: [
     %{
       module: %{name: "coin", namespace: nil},
       module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
       name: "TRANSFER",
       params: [
         "k:d1a361d721cf81dbc21f676e6897f7e7a336671c0d5d25f87c10933cac6d8cf7",
         "k:db776793be0fcf8e76c75bdb35a36e67f298111dc6145c66693b0133192e2616",
         2.33e-4
       ]
     }
   ],
   gas: 233,
   logs: "P3CDVUbCSSsXukPztkmLjJL7tsxNNIuPHKyhGMD_0wE",
   meta_data: %{
     block_hash: "Z9fszmqYV7s_rLyvvdAw5nbLqdMIj-_P4lPGFMLRy3M",
     block_height: 2_829_780,
     block_time: 1_671_476_220_495_690,
     prev_block_hash: "9LKeJBo1REDwbVUYjxKKvbuHN4kFRDmjxEqatUUPu8g"
   },
   req_key: "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc",
   result: %{data: 3, status: "success"},
   tx_id: 4_272_500
 }}
```

### SPV endpoint

Retrieves a SPV proof of a cross chain transaction. Request must be sent to the chain where the transaction is initiated.

```elixir
Kadena.Chainweb.Pact.spv(payload, network_opts \\ [network_id: :testnet04, chain_id: 0])
```

**Parameters**

- `payload`: Keyword list with:

  - `request_key` (required): String value. Request Key of an initiated cross chain transaction at the source chain.

  - `target_chain_id` (required): String-encoded integer from 0 to 19. Target chain id of the cross chain transaction.


- `network_opts`: Network options. Keyword list with:

  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `chain_id` (required): Allowed values: integer or string-encoded integer from 0 to 19.

  Defaults to `[network_id: :testnet04, chain_id: 0]` if not specified.

**Example**

```elixir
alias Kadena.Chainweb

payload = [request_key: "VB4ZKobzuo5Cwv5LT9kWKg-34u7KZ0Oo84jnIiujTGc", target_chain_id: "2"]

Chainweb.Pact.spv(payload, network_id: :testnet04, chain_id: 1)

{:ok,
 %Kadena.Chainweb.Pact.SPVResponse{
   proof:
     "eyJjaGFpbiI6Miwib2JqZWN0IjoiQUFBQUVBQUFBQUFBQUFBQ0FBRm5kSVUwc0tpRHJvUWQ0LWJxbHA4dThxd3BpdXRvdXVFXzFxY1JteUNsQUtBN1BRSGxRcTlPMmpQT0E3VlI5bXhVZm4yVDhGdjcxTFFfVTM3eEw5Q3hBYTdkN0lnWUFUZUgxLWNEb3RJbnVyRFZMX1FjYzJyTzFtR3BvY21TcWlfeUFiR1JrXzVnT0Jka0JXVWVLS0lnRHN1YWlmbGt4S0R0alJfSndSSmxPd2w3QUZ0ZWxrZXNWVkZ6aUMyUXgwUFczSmJPY3pQOFVINjRteVNWTTNHUGhxUE5BYWdtUEpTenRsUlNSOTJhNUl5d1dZYVlmREVweUljLWNwSG9VSDdSWTBWZkFGVmVlZG1qbUFZS1l4RTdoS1VZa0gtLWN0dkFWbUFuQWlPYm1xUmFsUnlfQUt0RWJnOU9BSzNyTUZfM01STUpkODFpZmJCdnBHT2Jxckk5bXZEU1U0cEpBYjMtcTdXYU9hTWVVVk9XdlI4NUxLQW9qbFdXLVRmeVdrRXJMLXBreGZtNkFPOURadkNIOExiZkwzYlFXOWRKbUN0VHRteXI3N3pNZGxNaGVvb1k5OHNDQWRKcF9rN0hNUXJpLUtSTEFWeHJkT1dCOEt4dk13UldsaDNHQTRFa2ZFTnhBSW83N29OWGlKb3hLOUdqWFVwcGJXWnhDY1Q5TVJwQ0NHTURsVndmdkpaREFOMlpWZW8wSUxVOXd1XzNlOTRLUUEtUk9SNk1LUFFBeWJ4VHczUzVLbFg4QVg2aFhmODljMGpLRzBqeUQ0cVZxR2hhaGp0ZjNsRGdaekdPbEhDY3FNd2NBQ01yVTEyM3VHbnRUTnpUVVljREF5bTZnU1c2MUxWeFp5SjZxMjBoQzRSR0FPQUxJbGVBVy1tYVlBdXVkN08xeGhQbVFlcFg0MzhrWXJCOVd1Z3ZRUXg4Iiwic3ViamVjdCI6eyJpbnB1dCI6IkFCUjdJbWRoY3lJNk1qTXpMQ0p5WlhOMWJIUWlPbnNpYzNSaGRIVnpJam9pYzNWalkyVnpjeUlzSW1SaGRHRWlPak45TENKeVpYRkxaWGtpT2lKV1FqUmFTMjlpZW5Wdk5VTjNkalZNVkRsclYwdG5MVE0wZFRkTFdqQlBiemcwYW01SmFYVnFWRWRqSWl3aWJHOW5jeUk2SWxBelEwUldWV0pEVTFOeldIVnJVSHAwYTIxTWFrcE1OM1J6ZUU1T1NYVlFTRXQ1YUVkTlJGOHdkMFVpTENKbGRtVnVkSE1pT2x0N0luQmhjbUZ0Y3lJNld5SnJPbVF4WVRNMk1XUTNNakZqWmpneFpHSmpNakZtTmpjMlpUWTRPVGRtTjJVM1lUTXpOalkzTVdNd1pEVmtNalZtT0Rkak1UQTVNek5qWVdNMlpEaGpaamNpTENKck9tUmlOemMyTnprelltVXdabU5tT0dVM05tTTNOV0prWWpNMVlUTTJaVFkzWmpJNU9ERXhNV1JqTmpFME5XTTJOalk1TTJJd01UTXpNVGt5WlRJMk1UWWlMREl1TXpObExUUmRMQ0p1WVcxbElqb2lWRkpCVGxOR1JWSWlMQ0p0YjJSMWJHVWlPbnNpYm1GdFpYTndZV05sSWpwdWRXeHNMQ0p1WVcxbElqb2lZMjlwYmlKOUxDSnRiMlIxYkdWSVlYTm9Jam9pY2tVM1JGVTRhbXhSVERsNFgwMVFXWFZ1YVZwS1pqVkpRMEpVUVVWSVFVbEdVVU5DTkdKc2IyWlFOQ0o5WFN3aWJXVjBZVVJoZEdFaU9tNTFiR3dzSW1OdmJuUnBiblZoZEdsdmJpSTZiblZzYkN3aWRIaEpaQ0k2TkRJM01qVXdNSDAifSwiYWxnb3JpdGhtIjoiU0hBNTEydF8yNTYifQ"
 }}
```
## Chainweb P2P API

Interaction with [Chainweb P2P API][chainweb_p2p_api_doc] is done through different modules that implement functions to access the endpoints.

### Cut

A cut represents a distributed state of a chainweb. It references one block header for each chain, such that those blocks are pairwise concurrent.

Two blocks from two different chains are said to be concurrent if either one of them is an adjacent parent (is a direct dependency) of the other or if the blocks do not depend at all on each other.

#### Query the current cut from a Chainweb node

```elixir
Kadena.Chainweb.P2P.Cut.retrieve(opts \\ [network_id: :testnet04, location: nil, query_params: nil])
```

**Parameters**

- `opts`: Network options. Keyword list with:
  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `location` (optional): Location to access a Chainweb P2P bootstrap node. Allowed values:
    - testnet: `"us1"`, `"us2"`, `"eu1"`, `"eu2"`, `"ap1"`, `"ap2"`
    - mainnet: `"us-e1"`, `"us-e2"`, `"us-e3"`, `"us-w1"`, `"us-w2"`, `"us-w3"`, `"fr1"`, `"fr2"`, `"fr3"`, `"jp1"`, `"jp2"`, `"jp3"`

  - `query_params` (optional): Query parameters. Keyword list with:

    - `maxheight` (optional): Integer or string-encoded integer `>= 0`, represents the maximum cut height of the returned cut.

  Defaults to `[network_id: :testnet04, location: nil, query_params: []]` if not specified.

**Example**

```elixir

alias Kadena.Chainweb.P2P.Cut

Cut.retrieve(network_id: :mainnet01, location: "jp2", query_params: [maxheight: 36543])

{:ok,
 %Kadena.Chainweb.P2P.CutResponse{
   hashes: %{
     "0": %{hash: "zkkjtWjiD68BcaISzjn5_y7-vQ3Yk2y3swhz7hm_7w8", height: 3654},
     "1": %{hash: "M-tbkEAVpS0-v5dxu-rxhRkjcVZfSE1nKEBBxNvka_g", height: 3654},
     "2": %{hash: "af5hWh0dUJoTGr5Bn8JxgDbAA97h6uqtclYi4SP95w8", height: 3654},
     "3": %{hash: "1-XVBn9NO2-g53WFzX9YpYT-t10Rr3RWJTdydMxK7Qg", height: 3654},
     "4": %{hash: "wphlMRCrkjVaIBlFNQdlTonLxGRebClL4DTHjZhgpXw", height: 3654},
     "5": %{hash: "T6iaDkYwzMBIBEyXgkFQ-T4FMhS__g6DACs4C8O27gg", height: 3654},
     "6": %{hash: "fX3NieTI5CjMs9VZEyfRqHg0B3ZKyxNkm7-p4TIfSZ4", height: 3654},
     "7": %{hash: "ddZN5o0ZNrcgmCOaEhyWb0rmpl0QcBguwfmop6uQKpI", height: 3654},
     "8": %{hash: "KEQkdXVF0nYujH43U0q-nkwDIUViZnncWol78Spoxow", height: 3654},
     "9": %{hash: "qqCoe3VfCyH6vJmn22RLIzD8DrDrKKjKlPn15UQ25TU", height: 3654}
   },
   height: 36540,
   id: "DeYKC0r8tXxZRYyx-S49sVzFCAZ8TZT3J1UlVSVmjCA",
   instance: "mainnet01",
   origin: nil,
   weight: "LKml1d8BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
 }}
```

### BlockHash

These endpoints return block hashes from the chain database. Generally, block hashes are returned in ascending order and include hashes from orphaned blocks.

For only querying blocks that are included in the winning `branch` of the chain the branch endpoint can be used, which returns blocks in descending order starting from the leafs of branches of the blockchain.

#### Get Block Hashes

A page of a collection of block hashes in ascending order that satisfies query parameters. Any block hash from the chain database is returned. This includes hashes of orphaned blocks.

```elixir
Kadena.Chainweb.P2P.BlockHash.retrieve(network_opts \\ [])
```

**Parameters**

- `network_opts`: Network options. Keyword list with:
  - `network_id` (required): Allowed values: `:testnet04` `:mainnet01`.
  - `location` (optional): Location to access a Chainweb P2P bootstrap node. Allowed values:
    - testnet: `"us1"`, `"us2"`, `"eu1"`, `"eu2"`, `"ap1"`, `"ap2"`
    - mainnet: `"us-e1"`, `"us-e2"`, `"us-e3"`, `"us-w1"`, `"us-w2"`, `"us-w3"`, `"fr1"`, `"fr2"`, `"fr3"`, `"jp1"`, `"jp2"`, `"jp3"`
  - `chain_id` (required): Id of the chain to which the request is sent. Allowed values: integer or string-encoded integer from 0 to 19.

  - `query_params` (optional): Query parameters. Keyword list with:

    - `limit` (optional): Integer (`>=0`) that represents the maximum number of records that may be returned.
    - `next` (optional): String of the cursor for the next page. This value can be found as value of the next property of the previous page.
    - `minheight` (optional): Integer (`>=0`) that represents the minimum block height of the returned headers.
    - `maxheight` (optional): Integer (`>=0`) that represents the maximum block height of the returned headers. 

  Defaults to `[network_id: :testnet04, location: nil, chain_id: 0, query_params: []]` if not specified.

**Example**

```elixir

alias Kadena.Chainweb.P2P.BlockHash

BlockHash.retrieve(location: "eu1", query_params: [limit: 5])

{:ok,
 %Kadena.Chainweb.P2P.BlockHashResponse{
   items: [
     "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE",
     "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo",
     "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
     "4kaI5Wk-t3mvNZoBmVECbk_xge5SujrVh1s8S-GESKI",
     "jVP-BDWC93RfDzBVQxolPJi7RcX09ax1IMg0_I_MNIk"
   ],
   limit: 5,
   next: "inclusive:gmV-pRi50fUcy2i9v8cba_HDjw2_GP47RKgpKD-0av8"
 }}
```
---

## Roadmap

The latest updated branch to target a PR is `v0.13`

You can see a big picture of the roadmap here: [**ROADMAP**][roadmap]

### What we're working on now 🎉

- [Chainweb P2P API](https://github.com/kommitters/kadena.ex/milestone/1)

### Done - What we've already developed! 🚀

<details>
<summary>Click to expand!</summary>

- [Base types](https://github.com/kommitters/kadena.ex/issues/11)
- [Keypair types](https://github.com/kommitters/kadena.ex/issues/12)
- [PactValue types](https://github.com/kommitters/kadena.ex/issues/15)
- [SignCommand types](https://github.com/kommitters/kadena.ex/issues/16)
- [ContPayload types](https://github.com/kommitters/kadena.ex/issues/28)
- [Cap types](https://github.com/kommitters/kadena.ex/issues/30)
- [ExecPayload types](https://github.com/kommitters/kadena.ex/issues/32)
- [PactPayload types](https://github.com/kommitters/kadena.ex/issues/34)
- [MetaData and Signer types](https://github.com/kommitters/kadena.ex/issues/35)
- [CommandPayload types](https://github.com/kommitters/kadena.ex/issues/36)
- [PactExec types](https://github.com/kommitters/kadena.ex/issues/40)
- [PactEvents types](https://github.com/kommitters/kadena.ex/issues/41)
- [CommandResult types](https://github.com/kommitters/kadena.ex/issues/43)
- [PactCommand types](https://github.com/kommitters/kadena.ex/issues/13)
- [PactAPI types](https://github.com/kommitters/kadena.ex/issues/17)
- [Wallet types](https://github.com/kommitters/kadena.ex/issues/18)
- [Kadena Crypto](https://github.com/kommitters/kadena.ex/issues/51)
- [Kadena Pact](https://github.com/kommitters/kadena.ex/issues/55)
- [Pact Commands Builder](https://github.com/kommitters/kadena.ex/issues/131)
- [Chainweb](https://github.com/kommitters/kadena.ex/issues/57)

</details>

---

## Development

- Install any Elixir version above 1.13.
- Compile dependencies: `mix deps.get`
- Run tests: `mix test`.

## Want to jump in?

Check out our [Good first issues][good-first-issues], this is a great place to start contributing if you're new to the project!

We welcome contributions from anyone! Check out our [contributing guide][contributing] for more information.

## Changelog

Features and bug fixes are listed in the [CHANGELOG][changelog] file.

## Code of conduct

We welcome everyone to contribute. Make sure you have read the [CODE_OF_CONDUCT][coc] before.

## Contributing

For information on how to contribute, please refer to our [CONTRIBUTING][contributing] guide.

## License

This library is licensed under an MIT license. See [LICENSE][license] for details.

## Acknowledgements

Made with 💙 by [kommitters Open Source](https://kommit.co)

[license]: https://github.com/kommitters/kadena.ex/blob/main/LICENSE
[coc]: https://github.com/kommitters/kadena.ex/blob/main/CODE_OF_CONDUCT.md
[changelog]: https://github.com/kommitters/kadena.ex/blob/main/CHANGELOG.md
[contributing]: https://github.com/kommitters/kadena.ex/blob/main/CONTRIBUTING.md
[roadmap]: https://github.com/orgs/kommitters/projects/5/views/3
[good-first-issues]: https://github.com/kommitters/kadena.ex/labels/%F0%9F%91%8B%20Good%20first%20issue
[http_client_spec]: https://github.com/kommitters/kadena.ex/blob/main/lib/chainweb/client/spec.ex
[jason_url]: https://github.com/michalmuskala/jason
[chainweb_pact_api_doc]: https://api.chainweb.com/openapi/pact.html
[chainweb_pact_api]: https://github.com/kommitters/kadena.ex/blob/main/lib/chainweb/pact.ex
[chainweb_p2p_api_doc]: https://api.chainweb.com/openapi/#tag/p2p_api
