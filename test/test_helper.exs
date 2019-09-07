ExUnit.start()
{:ok, _pid} = Supervisor.start_link([CPF.Support.Repo], strategy: :one_for_one)
Ecto.Adapters.SQL.Sandbox.mode(CPF.Support.Repo, :manual)
