defmodule CPF.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpf,
      version: "0.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "CPF",
      source_url: "https://github.com/ulissesalmeida/cpf"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.20.1"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def description do
    "A Brazilian CPF validation written in Elixir."
  end

  def package do
    [
      name: "cpf",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ulissesalmeida/cpf"}
    ]
  end
end
