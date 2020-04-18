if Code.ensure_loaded?(Ecto.Type) do
  defmodule CPF.Ecto.Type.Bigint do
    @moduledoc false
    use Ecto.Type

    require CPF

    @impl true
    def type, do: :bigint

    @impl true
    def cast(%CPF{} = cpf), do: {:ok, cpf}

    def cast(input) do
      case CPF.parse(input) do
        {:ok, cpf} -> {:ok, cpf}
        {:error, %CPF.ParsingError{reason: reason}} -> {:error, [reason: reason]}
      end
    end

    @impl true
    def load(data) when is_integer(data), do: {:ok, CPF.new(data)}

    @impl true
    def dump(cpf) do
      if CPF.cpf?(cpf), do: {:ok, CPF.to_integer(cpf)}, else: :error
    end

    @impl true
    def embed_as(_format), do: :dump
  end
end
