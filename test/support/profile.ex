defmodule CPF.Support.EmbedProfile do
  @moduledoc false

  use Ecto.Schema

  import CPF.Ecto.Type

  embedded_schema do
    field :string_cpf, cpf_type(:string)
    field :integer_cpf, cpf_type(:bigint)
  end
end

defmodule CPF.Support.Profile do
  @moduledoc false

  use Ecto.Schema

  alias CPF.Support.EmbedProfile

  import Ecto.Changeset
  import CPF.Ecto.Type

  schema "profiles" do
    field :string_cpf, cpf_type(:string)
    field :integer_cpf, cpf_type(:bigint)
    field :cpf, :string

    field :cpf_string_list, {:array, cpf_type(:string)}, deafult: []
    field :cpf_integer_list, {:array, cpf_type(:bigint)}, default: []

    embeds_one :embed_profile, EmbedProfile
  end

  def new(enum \\ %{}), do: struct!(__MODULE__, enum)

  def changeset(profile, params),
    do: cast(profile, params, __schema__(:fields) -- [:embed_profile])
end
