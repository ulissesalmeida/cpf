defmodule CPF.Support.Repo.Migrations.AddEmbededCpf do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :cpf_string_list, {:array, :string}, default: [], null: false
      add :cpf_integer_list, {:array, :bigint}, default: [], null: false
      add :embed_profile, :map, default: %{}, null: false
    end
  end
end
