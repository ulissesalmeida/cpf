defmodule CPF.Support.Repo.Migrations.AddProfile do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :string_cpf, :string
      add :integer_cpf, :bigint
    end
  end
end
