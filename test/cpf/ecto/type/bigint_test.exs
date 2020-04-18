defmodule CPF.Ecto.Type.BigintTest do
  use CPF.DataCase, async: false

  test "inserts and reads CPFs" do
    cpf = CPF.generate()

    profile = Repo.insert!(%Profile{integer_cpf: cpf})
    profile_from_db = Repo.get(Profile, profile.id)

    assert profile_from_db.integer_cpf == cpf
  end

  test "doesn't insert invalid CPFs" do
    assert_raise Ecto.ChangeError, fn ->
      Repo.insert!(%Profile{integer_cpf: "abilidebob"})
    end
  end

  test "insert array of string CPFs" do
    cpf = CPF.generate()

    profile = Repo.insert!(%Profile{cpf_integer_list: [cpf]})
    profile_from_db = Repo.get(Profile, profile.id)

    assert profile_from_db.cpf_integer_list == [cpf]
  end

  test "insert embeded profile" do
    cpf = CPF.generate()

    profile =
      Repo.insert!(%Profile{
        embed_profile: %EmbedProfile{
          integer_cpf: cpf
        }
      })

    profile_from_db = Repo.get(Profile, profile.id)

    assert profile_from_db.embed_profile.integer_cpf == cpf
  end

  test "queries by CPF" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{integer_cpf: cpf})

    query = from p in Profile, where: p.integer_cpf == ^cpf

    assert [found_profile] = Repo.all(query)
    assert found_profile.id == profile.id
  end

  test "queries by CPF string" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{integer_cpf: cpf})

    query = from p in Profile, where: p.integer_cpf == ^to_string(cpf)

    assert [found_profile] = Repo.all(query)
    assert found_profile.id == profile.id
  end

  test "queries by CPF integer" do
    cpf = CPF.generate()
    profile = Repo.insert!(%Profile{integer_cpf: cpf})

    query = from p in Profile, where: p.integer_cpf == ^CPF.to_integer(cpf)

    assert [found_profile] = Repo.all(query)
    assert found_profile.id == profile.id
  end

  test "doesn't query with invalid CPFs." do
    cpf = CPF.generate()
    Repo.insert!(%Profile{integer_cpf: cpf})

    query = from p in Profile, where: p.integer_cpf == ^"aaa"

    assert_raise Ecto.Query.CastError, fn ->
      Repo.all(query)
    end
  end

  test "casts CPFs from strings on changesets" do
    cpf = CPF.generate()

    assert {:ok, %Profile{integer_cpf: cast_cpf}} =
             Profile.new()
             |> Profile.changeset(%{integer_cpf: to_string(cpf)})
             |> apply_action(:insert)

    assert cast_cpf == cpf
  end

  test "casts CPFs from integers on changesets" do
    cpf = CPF.generate()

    assert {:ok, %Profile{integer_cpf: cast_cpf}} =
             Profile.new()
             |> Profile.changeset(%{integer_cpf: CPF.to_integer(cpf)})
             |> apply_action(:insert)

    assert cast_cpf == cpf
  end

  test "returns error on invalid CPFs" do
    cpf = "abilidebob"

    assert {:error, changeset} =
             Profile.new()
             |> Profile.changeset(%{integer_cpf: cpf})
             |> apply_action(:insert)

    assert {"is invalid", details} = Keyword.get(changeset.errors, :integer_cpf)
    assert :invalid_format = Keyword.get(details, :reason)
  end
end
