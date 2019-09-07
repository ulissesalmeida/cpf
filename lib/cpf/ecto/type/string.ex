if Code.ensure_loaded?(Ecto.Type) do
  defmodule CPF.Ecto.Type.String do
    @moduledoc false

    use Ecto.Type

    def type, do: :string

    def cast(%CPF{} = cpf), do: {:ok, cpf}

    def cast(input) do
      case CPF.parse(input) do
        {:ok, cpf} -> {:ok, cpf}
        {:error, %CPF.ParsingError{reason: reason}} -> {:error, [reason: reason]}
      end
    end

    def load(data) when is_binary(data), do: {:ok, CPF.new(data)}

    def dump(cpf) do
      if CPF.cpf?(cpf), do: {:ok, to_string(cpf)}, else: :error
    end
  end
end
