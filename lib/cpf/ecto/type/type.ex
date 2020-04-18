if Code.ensure_loaded?(Ecto.Type) do
  defmodule CPF.Ecto.Type do
    @moduledoc """
    Provide you functions to use the CPF type in your Ecto schema fields.

    ## Usage

        defmodule MyApp.MySchema do
          use Ecto.Schema
          # Import the cpf_type/1 helper
          import CPF.Ecto.Type

          schema "my_schemas" do
            # use the helpers functions in any field
            field :cpf, cpf_type(:string)
          end
        end
    """

    @doc """
      A parameterized `type` macro function.

      - `cpf_type(:bigint)` is a alias for `CPF.Ecto.Type.Bigint`
      - `cpf_type(:string)` is a alias for `CPF.Ecto.Type.String`
    """
    @spec cpf_type(:bigint | :string) :: Macro.t()
    defmacro cpf_type(:bigint) do
      quote do
        CPF.Ecto.Type.Bigint
      end
    end

    defmacro cpf_type(:string) do
      quote do
        CPF.Ecto.Type.String
      end
    end
  end
end
