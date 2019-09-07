defmodule CPF.Ecto.Type.StringTest do
  use CPF.DataCase, async: false

  test "inserts and reads CPFs" do
    cpf = CPF.generate()

    profile = Repo.insert!(%Profile{string_cpf: cpf})
    profile_from_db = Repo.get(Profile, profile.id)

    assert profile_from_db.string_cpf == cpf
  end

  test "doesn't insert invalid CPFs" do
    assert_raise Ecto.ChangeError, fn ->
      Repo.insert!(%Profile{string_cpf: "abilidebob"})
    end
  end

  test "queries by CPF" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{string_cpf: cpf})

    query = from p in Profile, where: p.string_cpf == ^cpf

    assert [^profile] = Repo.all(query)
  end

  test "queries by CPF string" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{string_cpf: cpf})

    query = from p in Profile, where: p.string_cpf == ^to_string(cpf)

    assert [^profile] = Repo.all(query)
  end

  test "queries by CPF integer" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{string_cpf: cpf})

    query = from p in Profile, where: p.string_cpf == ^CPF.to_integer(cpf)

    assert [^profile] = Repo.all(query)
  end

  test "doesn't query with invalid CPFs." do
    cpf = CPF.generate()
    Repo.insert!(%Profile{string_cpf: cpf})

    query = from p in Profile, where: p.string_cpf == ^"aaa"

    assert_raise Ecto.Query.CastError, fn ->
      Repo.all(query)
    end
  end

  test "casts CPFs from strings on changesets" do
    cpf = CPF.generate()

    assert {:ok, %Profile{string_cpf: cast_cpf}} =
             Profile.new()
             |> Profile.changeset(%{string_cpf: to_string(cpf)})
             |> apply_action(:insert)

    assert cast_cpf == cpf
  end

  test "casts CPFs from integers on changesets" do
    cpf = CPF.generate()

    assert {:ok, %Profile{string_cpf: cast_cpf}} =
             Profile.new()
             |> Profile.changeset(%{string_cpf: CPF.to_integer(cpf)})
             |> apply_action(:insert)

    assert cast_cpf == cpf
  end

  test "returns error on invalid CPFs" do
    cpf = "abilidebob"

    assert {:error, changeset} =
             Profile.new()
             |> Profile.changeset(%{string_cpf: cpf})
             |> apply_action(:insert)

    assert {"is invalid", details} = Keyword.get(changeset.errors, :string_cpf)
    assert :invalid_format = Keyword.get(details, :reason)
  end
end
