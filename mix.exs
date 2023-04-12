defmodule CPF.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpf,
      version: "1.2.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "CPF",
      docs: docs(),
      aliases: aliases(),
      dialyzer: [
        plt_file: {:no_warn, "plts/dialyzer.plt"},
        plt_add_apps: [:mix, :ex_unit, :ecto, :ecto_sql]
      ],
      preferred_cli_env: [dialyzer: :test, unit_test: :test]
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
      {:ex_doc, "~> 0.20", only: [:docs], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test], runtime: false},
      {:postgrex, "~> 0.17.0", only: [:test]}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ] ++ ecto_deps()
  end

  defp ecto_deps do
    [
      {:ecto, "~> 3.2", optional: true},
      {:ecto_sql, "~> 3.2", only: [:dev, :test], optional: true}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def description do
    "A Brazilian CPF validation written in Elixir."
  end

  def package do
    [
      name: "cpf",
      maintainers: ["Ulisses Almeida"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/ulissesalmeida/cpf"}
    ]
  end

  def docs do
    [
      source_url: "https://github.com/ulissesalmeida/cpf",
      extras: ["README.md"]
    ]
  end

  def aliases do
    [
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      unit_test: ["test --exclude data_case"]
    ]
  end
end
