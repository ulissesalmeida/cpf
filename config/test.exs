use Mix.Config

config :cpf, CPF.Support.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: System.get_env("POSTGRES_DB") || "cpf_test",
  hostname: System.get_env("POSTGRES_HOSTNAME") || "localhost",
  pool_size: 10,
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/priv/repo"

config :cpf, ecto_repos: [CPF.Support.Repo]
