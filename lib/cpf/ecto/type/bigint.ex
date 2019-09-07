if Code.ensure_loaded?(Ecto.Type) do
  defmodule CPF.Ecto.Type.Bigint do
    @moduledoc false
    use Ecto.Type

    require CPF

    def type, do: :bigint

    def cast(%CPF{} = cpf), do: {:ok, cpf}

    def cast(input) do
      case CPF.parse(input) do
        {:ok, cpf} -> {:ok, cpf}
        {:error, %CPF.ParsingError{reason: reason}} -> {:error, [reason: reason]}
      end
    end

    def load(data) when is_integer(data), do: {:ok, CPF.new(data)}

    def dump(cpf) do
      if CPF.cpf?(cpf), do: {:ok, CPF.to_integer(cpf)}, else: :error
    end
  end
end
