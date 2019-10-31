defmodule CPF.Ecto.ChangesetTest do
  use ExUnit.Case, async: true

  doctest CPF.Ecto.Changeset

  alias CPF.Ecto.Changeset
  alias CPF.Support.Profile

  describe "validate_cpf" do
    test "adds error and reason to invalid cpf field" do
      assert [cpf: {"is invalid", [reason: :invalid_format]}] ==
               Profile.new()
               |> Profile.changeset(%{"cpf" => "abilidebob"})
               |> Changeset.validate_cpf(:cpf)
               |> Map.get(:errors)
    end

    test "is ok with a valid cpf" do
      assert [] ==
               Profile.new()
               |> Profile.changeset(%{"cpf" => CPF.generate() |> to_string()})
               |> Changeset.validate_cpf(:cpf)
               |> Map.get(:errors)
    end
  end
end
