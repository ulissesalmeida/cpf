if Code.ensure_loaded?(Ecto.Changeset) do
  defmodule CPF.Ecto.Changeset do
    @moduledoc """
    Provide functions to validate CPF field in a changeset.
    """

    @type changeset :: Ecto.Changeset.t()

    @doc """
    Verifies if given `field` in the `changeset` has a valid CPF.

    ## Examples

        iex> {%{}, %{cpf: :string}}
        ...>  |> Ecto.Changeset.cast(%{"cpf" => "aaa"}, [:cpf])
        ...>  |> CPF.Ecto.Changeset.validate_cpf(:cpf)
        ...>  |> Map.get(:errors)
        [cpf: {"is invalid", [reason: :invalid_format]}]

        iex> {%{}, %{cpf: :string}}
        ...>  |> Ecto.Changeset.cast(%{"cpf" => "429.329.147-40"}, [:cpf])
        ...>  |> CPF.Ecto.Changeset.validate_cpf(:cpf)
        ...>  |> Map.get(:errors)
        []

        iex> {%{}, %{cpf: :string}}
        ...>  |> Ecto.Changeset.cast(%{"cpf" => "42932914740"}, [:cpf])
        ...>  |> CPF.Ecto.Changeset.validate_cpf(:cpf)
        ...>  |> Map.get(:errors)
        []
    """
    @spec validate_cpf(changeset, atom) :: changeset
    def validate_cpf(changeset, field),
      do: Ecto.Changeset.validate_change(changeset, field, &validate/2)

    defp validate(field, value) do
      case CPF.parse(value) do
        {:ok, _cpf} ->
          []

        {:error, %CPF.ParsingError{reason: reason}} ->
          [{field, {"is invalid", [reason: reason]}}]
      end
    end
  end
end
