# Kadena.ex

**Kadena.ex** is an Open-Source library for Elixir that allows developers to interact with Kadena and its Chainweb.

## What can I do with Kadena.ex? 

* Construct commands for transactions.
* Implement cryptography required by the network.
* Interact with public network endpoints: 
    - listen, local, poll, send, spv, cut.
* Send, test and update smart contracts on the network.

## Installation

Add `kadena` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kadena, "~> 0.1.0"}
  ]
end
```

## Roadmap

The latest updated branch to target a PR is `v0.2`

You can see a big picture of the roadmap here: [ROADMAP][roadmap]

### Short term - what we're working on now 🎉

- [PactCommand types](https://github.com/kommitters/kadena.ex/issues/13)
- [PactAPI types](https://github.com/kommitters/kadena.ex/issues/17)
- [Wallet types](https://github.com/kommitters/kadena.ex/issues/18)

### Medium term - what we're working on next! 🍰

- [Kadena crypto](https://github.com/kommitters/kadena.ex/issues/51)
- [Kadena PACT](https://github.com/kommitters/kadena.ex/issues/55)
- [Kadena API](https://github.com/kommitters/kadena.ex/issues/56)
- [Kadena chainweb](https://github.com/kommitters/kadena.ex/issues/57)

### Done - What we've already developed! 🚀

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

---

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
