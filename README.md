# Kadena.ex

![Build Badge](https://img.shields.io/github/workflow/status/kommitters/kadena.ex/Kadena%20CI/main?style=for-the-badge)
[![Coverage Status](https://img.shields.io/coveralls/github/kommitters/kadena.ex?style=for-the-badge)](https://coveralls.io/github/kommitters/kadena.ex)
[![Version Badge](https://img.shields.io/hexpm/v/kadena?style=for-the-badge)](https://hexdocs.pm/kadena)
![Downloads Badge](https://img.shields.io/hexpm/dt/kadena?style=for-the-badge)
[![License badge](https://img.shields.io/hexpm/l/kadena?style=for-the-badge)](https://github.com/kommitters/kadena.ex/blob/main/LICENSE)

**Kadena.ex** is an open source library for Elixir that allows developers to interact with the Kadena Chainweb.

## What can you do with Kadena.ex?

- Construct commands for transactions.
- Implement cryptography required by the network.
- Interacting with public network endpoints:
  - listen, local, poll, send, spv, cut.
- Send, test and update smart contracts on the network.

## Installation

Add `kadena` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kadena, "~> 0.8.0"}
  ]
end
```

## Roadmap

The latest updated branch to target a PR is `v0.9`

You can see a big picture of the roadmap here: [**ROADMAP**][roadmap]

### What we're working on now 🎉

- [Chainweb](https://github.com/kommitters/kadena.ex/issues/57)
- [Pact Commands Builder](https://github.com/kommitters/kadena.ex/issues/131)

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

</details>

---

## Building Commands

This library allows to build command payloads in a composable and semantic manner.
These commands are intended to be used as the request body to the Pact API endpoints.

There are two type of commands:

- [`Execution`](#execution-command)
- `Continuation`.

### Execution Command

To create an execution command is needed:

- [NetworkID](#networkid)
- [Code](#code)
- [Nonce](#nonce)
- [EnvData](#envdata) (optional)
- [MetaData](#metadata)
- [KeyPairs](#keypair)
- [Signers](#signerslist)

The following example shows how to create an execution command:

```elixir
Kadena.Pact.ExecCommand.new()
  |> Kadena.Pact.ExecCommand.set_network(network_id)
  |> Kadena.Pact.ExecCommand.set_code(code)
  |> Kadena.Pact.ExecCommand.set_nonce(nonce)
  |> Kadena.Pact.ExecCommand.set_data(env_data)
  |> Kadena.Pact.ExecCommand.set_metadata(keypair)
  |> Kadena.Pact.ExecCommand.add_keypair(keypair)
  |> Kadena.Pact.ExecCommand.add_signers(signers_list)
  |> Kadena.Pact.ExecCommand.build()
```

#### NetworkID

There are three options allowed to set a NetworkID:

- `:testnet04`
- `:mainnet01`
- `:development`

#### Code

String value that represents the Pact code to execute in the `Execution Command`.

#### Nonce

String value to ensure unique hash. You can use current timestamp.

#### EnvData

A map must be provided to create an environment data, for example:

```elixir
data = %{
  accounts_admin_keyset: [
    "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"
  ]
}

Kadena.Types.EnvData.new(data)
```

#### MetaData

To create a MetaData:

```elixir
raw_metadata = [
  creation_time: 0,
  ttl: 0,
  gas_limit: 2500,
  gas_price: 1.0e-2,
  sender: "account_name",
  chain_id: "0"
]

Kadena.Types.MetaData.new(raw_metadata)
```

#### KeyPairs

There are two ways to get a keypair:

```elixir
# generate a random keypair
{:ok, %Kadena.Types.KeyPair{} = keypair} = Kadena.Cryptography.KeyPair.generate()

# derive a keypair from a secret key
secret_key = "secret_key_value"
{:ok, %Kadena.Types.KeyPair{} = keypair} = Kadena.Cryptography.KeyPair.from_secret_key(secret_key)
```


**KeyPairs with Capabilites**

Creating a keypair with capabilities:

```elixir
clist =
  Kadena.Types.CapsList.new([
    [name: "gas", args: ["COIN.gas", 0.02]],
    [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
  ])

keypair_values = [
  pub_key: "pub_key_value",
  secret_key: "secret_key_value",
  clist: clist
]

Kadena.Types.KeyPair.new(keypair_values)
```

Adding capabilities to existing keypair:
```elixir
clist =
  Kadena.Types.CapsList.new([
    [name: "gas", args: ["COIN.gas", 0.02]],
    [name: "transfer", args: ["COIN.transfer", "key_1", 50, "key_2"]]
  ])


secret_key = "secret_key_value"
{:ok, %Kadena.Types.KeyPair{} = keypair} = Kadena.Cryptography.KeyPair.from_secret_key(secret_key)

keypair_with_clist = Kadena.Types.KeyPair.add_caps(keypair, clist)
```

#### SignersList

There are two ways to create a list of signers:

```elixir
# with Keywords
signer1 = [pub_key: "pub_key_1"]
signer2 = [pub_key: "pub_key_2"]

# with Signer structs
signer1 = Kadena.Types.Signer.new([pub_key: "pub_key_1"])
signer2 = Kadena.Types.Signer.new([pub_key: "pub_key_2"])

Kadena.Types.SignersList.new([signer1, signer2])
```

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
