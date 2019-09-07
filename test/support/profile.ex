defmodule CPF.Support.Profile do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import CPF.Ecto.Type

  schema "profiles" do
    field :string_cpf, cpf_type(:string)
    field :integer_cpf, cpf_type(:bigint)
  end

  def new(enum \\ %{}), do: struct!(__MODULE__, enum)

  def changeset(profile, params), do: cast(profile, params, __schema__(:fields))
end
