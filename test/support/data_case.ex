defmodule CPF.DataCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias CPF.Support.Repo
  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      alias CPF.Support.{EmbedProfile, Profile, Repo}

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Repo)

    unless tags[:async] do
      Sandbox.mode(Repo, {:shared, self()})
    end

    :ok
  end
end
