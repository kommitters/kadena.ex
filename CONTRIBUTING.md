# How to contribute

First off, thanks for taking the time to contribute, it is encouraging! 🎉🙌

We want to make it as easy as possible to contribute changes that help the [Kadena][repo] library and the [Kadena network][kadena] to grow and thrive. There are a few guidelines that we ask contributors to follow so that we can merge your changes quickly.

## Getting started

* Make sure you have a [GitHub account][github-signup].
* Create a GitHub issue for your contribution, assuming one does not already exist.
  * Clearly describe the issue including steps to reproduce if it is a bug.
* Fork the repository on GitHub.
* Try to keep your local repository in a "rebased" state.
* Set the project up.
  * Install any Elixir version above 1.10.
  * Compile dependencies: `mix deps.get`.
  * Run tests: `mix test`.

## Finding things to work on

The first place to start is always looking over the current GitHub issues for the project you are
interested in contributing to. Issues marked with [good first issue][good-first-issue] or [help wanted][help-wanted] are usually pretty self-contained and a good place to get started.

If you see any issues that are assigned to a particular person or have the `work in progress` label, that means
someone is currently working on that issue this issue in the next week or two.

Of course, feel free to create a new issue if you think something needs to be added or fixed.

## Making changes

* Create a topic branch from where you want to base your work `git checkout -b my-branch-name`.
  * This is usually the main branch.
  * Please avoid working directly on the `main` branch.
* Make sure you have added the necessary tests for your changes and make sure all tests pass.
* Make sure your code is properly formatted by running `mix format`.

## Submitting changes

* All content, comments, pull requests and other contributions must comply with the
  [Code of Conduct][coc].
* Push your changes to a topic branch in your fork of the repository.
* Submit a pull request.
  * Include a descriptive [commit message][commit-msg].
  * Changes contributed via pull request should focus on a single issue at a time.
  * Rebase your local changes against the main branch. Resolve any conflicts that arise.

At this point, you're waiting on us. We like to at least comment on pull requests within three
business days (typically, one business day). We may suggest some changes, improvements or
alternatives.

## Resources

- [How to Contribute to Open Source][oss-how-to]
- [Using Pull Requests][github-help-pr]
- [GitHub Help][github-help]

## Contact

Get in touch: [oss@kommit.co][mail-to] | [@kommitters_oss][twitter] on Twitter.

## Acknowledgements

This document is inspired by:
* https://github.com/kommitters/stellar_sdk/blob/main/CONTRIBUTING.md

[twitter]: https://twitter.com/kommitters_oss
[mail-to]: mailto:oss@kommit.co
[github-signup]: https://github.com/signup/free
[oss-how-to]: https://opensource.guide/how-to-contribute
[repo]: https://github.com/kommitters/kadena
[coc]: https://github.com/kommitters/kadena/blob/main/CODE_OF_CONDUCT.md
[commit-msg]: https://github.com/erlang/otp/wiki/Writing-good-commit-messages
[good-first-issue]: https://github.com/kommitters/kadena/labels/%F0%9F%91%8B%20%20Good%20first%20issue
[help-wanted]: https://github.com/kommitters/kadena/labels/%3Asos%3A%20Help%20wanted
[kadena]: https://docs.kadena.io/
