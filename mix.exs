defmodule Blockchain.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Blockchain.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gb_merkle_trees, git: "https://github.com/aeternity/gb_merkle_trees.git", ref: "4db7aad"}
    ]
  end
end
