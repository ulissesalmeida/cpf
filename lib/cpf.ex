defmodule CPF do
  @moduledoc """
  CPF module that provides functions to verify if a CPF is valid.
  """

  @typedoc """
  A custom CPF type that can be a number or string
  """
  @type t :: integer | String.t()

  @doc """
  Returns `true` the given `cpf` is valid, otherwise `false`.

  ## Examples

      iex> CPF.valid?(563_606_676_73)
      true

      iex> CPF.valid?(563_606_676_72)
      false

      iex> CPF.valid?("563.606.676-73")
      true

      iex> CPF.valid?("563/60.6-676/73")
      false

      iex> CPF.valid?("563.606.676-72")
      false

      iex> CPF.valid?("56360667673")
      true

      iex> CPF.valid?("56360667672")
      false
  """
  @spec valid?(t) :: boolean
  def valid?(cpf) when is_integer(cpf) do
    cpf_digits = Integer.digits(cpf)
    padding = 11 - length(cpf_digits)
    same_digits? = cpf_digits |> Enum.uniq() |> length() == 1

    if padding >= 0 && !same_digits? do
      cpf_digits = cpf_digits |> add_padding(padding) |> List.to_tuple()
      {v1, v2} = calculate_verifier_digits(cpf_digits)
      {given_v1, given_v2} = extract_given_verifier_digits(cpf_digits)

      v1 == given_v1 && v2 == given_v2
    else
      false
    end
  end

  def valid?(
        <<left_digits::bytes-size(3)>> <>
          "." <>
          <<middle_digits::bytes-size(3)>> <>
          "." <>
          <<right_digits::bytes-size(3)>> <>
          "-" <>
          <<verifier_digits::bytes-size(2)>>
      ) do
    valid?(left_digits <> middle_digits <> right_digits <> verifier_digits)
  end

  def valid?(cpf) when is_binary(cpf) do
    case Integer.parse(cpf) do
      {cpf_int, ""} ->
        valid?(cpf_int)

      _ ->
        false
    end
  end

  def valid?(_cpf), do: false

  defp add_padding(digits, 0), do: digits

  defp add_padding(digits, padding) do
    add_padding([0 | digits], padding - 1)
  end

  defp calculate_verifier_digits(digits) do
    {v1_sum, v2_sum} = sum_digits(digits)

    v1 = digit_verifier(v1_sum)
    v2_sum = v2_sum + 2 * v1
    v2 = digit_verifier(v2_sum)

    {v1, v2}
  end

  defp sum_digits(digits) do
    v1_weight = 10
    v2_weight = 11

    Enum.reduce(0..8, {0, 0}, fn i, {v1_sum, v2_sum} ->
      v1 = (v1_weight - i) * elem(digits, i)
      v2 = (v2_weight - i) * elem(digits, i)

      {v1_sum + v1, v2_sum + v2}
    end)
  end

  defp digit_verifier(sum) do
    rem = rem(sum, 11)
    if rem in [0, 1], do: 0, else: 11 - rem
  end

  defp extract_given_verifier_digits(digits) do
    {elem(digits, 9), elem(digits, 10)}
  end
end
