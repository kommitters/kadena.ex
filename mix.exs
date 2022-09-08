defmodule Kadena.MixProject do
  use Mix.Project

  @version "0.1.0"
  @github_url "https://github.com/kommitters/kadena"

  def project do
    [
      app: :kadena,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Kadena",
      description: description(),
      source_url: @github_url,
      package: package(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: [:kadena, :ex_unit],
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Elixir library to interact with the Kadena blockchain.
    """
  end

  defp package do
    [
      description: description(),
      files: ["lib", "config", "mix.exs", "README*", "LICENSE"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "#{@github_url}/blob/master/CHANGELOG.md",
        "GitHub" => @github_url,
        "Sponsor" => "https://github.com/sponsors/kommitters"
      }
    ]
  end

  defp docs do
    [
      main: "readme",
      name: "Elixir Kadena",
      source_ref: "v#{@version}",
      source_url: @github_url,
      canonical: "http://hexdocs.pm/kadena",
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      groups_for_modules: groups_for_modules()
    ]
  end

  defp extras() do
    [
      "README.md",
      "CHANGELOG.md",
      "CONTRIBUTING.md",
      "docs/examples.md",
      "docs/examples/kadena.md"
    ]
  end

  defp groups_for_extras do
    [
      Examples: ~r/docs\/examples\/.?/
    ]
  end

  defp groups_for_modules do
    [
      "Initial release": [
        Kadena
      ]
    ]
  end
end
