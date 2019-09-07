defmodule CPF.Support.Helpers do
  @moduledoc false

  alias __MODULE__

  defmacro to_11_digits(digit) do
    quote do
      Helpers.eleven_digits(unquote(digit))
    end
  end

  def eleven_digits(digit) do
    0..10
    |> Enum.reduce(0, fn i, sum -> sum + :math.pow(10, i) * digit end)
    |> trunc()
  end
end
