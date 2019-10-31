defmodule Bench.MixProject do
  use Mix.Project

  def project do
    [
      app: :cpf_bench,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases() do
    [
      "bench.validate": ["run validate.exs"],
      "bench.format": ["run format.exs"],
      "bench.generate": ["run generate.exs"]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:cpf, "~> 1.0", path: "../", override: true},
      {:brcpfcnpj, "~> 0.2.0"},
      {:benchee, "~> 1.0"}
    ]
  end
end
