defmodule CPF do
  @moduledoc """
  CPF module that provides functions to verify if a CPF is valid.
  """

  defstruct [:digits]

  # NOTE: Remove Elixir 1.5 support when lauching CPF 1.0
  # defguardp is_pos_integer(number) when is_integer(number) and number >= 0

  @typep digit :: pos_integer()

  @typedoc """
  The CPF type. It' composed of eleven digits(0-9]).
  """
  @opaque t :: %__MODULE__{
            digits: {digit, digit, digit, digit, digit, digit, digit, digit, digit, digit, digit}
          }

  @doc """
  Initializes a CPF.

  ## Examples

      iex> CPF.new(563_606_676_73)
      #CPF<563.606.676-73>

      iex> CPF.new("56360667673")
      #CPF<563.606.676-73>

  This function doesn't check if CPF numbers are valid, only use this function
  if the given `String.t` or the integer was validated before.
  """
  @spec new(String.t() | pos_integer) :: t
  def new(cpf) when is_integer(cpf) and cpf >= 0 do
    %__MODULE__{
      digits: to_digits(cpf)
    }
  end

  def new(cpf) when is_binary(cpf) do
    %__MODULE__{
      digits: cpf |> String.to_integer() |> to_digits()
    }
  end

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
  @spec valid?(input :: String.t() | pos_integer) :: boolean
  def valid?(cpf) when (is_integer(cpf) and cpf >= 0) or is_binary(cpf) do
    case parse(cpf) do
      {:ok, _cpf} -> true
      {:error, _reason} -> false
    end
  end

  def valid?(_cpf) do
    IO.warn("""
    Calling `CPF.valid?/1` with invalid types is deprecated and will be removed
    on version 1.0.0. Only call this function with positive integers or strings.
    """)

    false
  end

  @doc """
  Returns a formatted string from a given  `cpf`.

  ## Examples

      iex> 563_606_676_73 |> CPF.new() |> CPF.format()
      "563.606.676-73"
  """
  @spec format(cpf :: t()) :: String.t()
  def format(%CPF{digits: digits}) do
    {dig_1, dig_2, dig_3, dig_4, dig_5, dig_6, dig_7, dig_8, dig_9, dig_10, dig_11} = digits

    to_string(dig_1) <>
      to_string(dig_2) <>
      to_string(dig_3) <>
      "." <>
      to_string(dig_4) <>
      to_string(dig_5) <>
      to_string(dig_6) <>
      "." <>
      to_string(dig_7) <>
      to_string(dig_8) <> to_string(dig_9) <> "-" <> to_string(dig_10) <> to_string(dig_11)
  end

  @doc """
  Builds a CPF struct by validating its digits and format. Returns an ok/error tuple for
  valid/invalid CPFs.

  ## Examples

      iex> {:ok, cpf} = CPF.parse(563_606_676_73)
      iex> cpf
      #CPF<563.606.676-73>

      iex> CPF.parse(563_606_676_72)
      {:error, %CPF.ParsingError{reason: :invalid_verifier}}
  """
  @spec parse(String.t() | pos_integer) :: {:ok, t()} | {:error, CPF.ParsingError.t()}
  def parse(cpf) when is_integer(cpf) and cpf >= 0 do
    digits = Integer.digits(cpf)

    with {:ok, digits} <- add_padding(digits),
         {:ok, digits} <- skip_same_digits(digits),
         {:ok, digits} <- verify_digits(digits) do
      {:ok, %CPF{digits: digits}}
    end
  end

  def parse(
        <<left_digits::bytes-size(3)>> <>
          "." <>
          <<middle_digits::bytes-size(3)>> <>
          "." <>
          <<right_digits::bytes-size(3)>> <>
          "-" <>
          <<verifier_digits::bytes-size(2)>>
      ) do
    parse(left_digits <> middle_digits <> right_digits <> verifier_digits)
  end

  def parse(cpf) when is_binary(cpf) do
    case Integer.parse(cpf) do
      {cpf_int, ""} ->
        parse(cpf_int)

      _ ->
        {:error, %CPF.ParsingError{reason: :invalid_format}}
    end
  end

  @doc """
  Builds a CPF struct by validating its digits and format. Returns an CPF type
  or raises an `CPF.ParsingError` exception.

  ## Examples

      iex> CPF.parse!(563_606_676_73)
      #CPF<563.606.676-73>

      iex> CPF.parse!(563_606_676_72)
      ** (CPF.ParsingError) invalid_verifier
  """
  @spec parse!(String.t() | pos_integer) :: t()
  def parse!(cpf) do
    case parse(cpf) do
      {:ok, cpf} -> cpf
      {:error, exception} -> raise exception
    end
  end

  @doc """
  Returns a tuple with the eleven digits of the given cpf.
  """
  @spec digits(t) :: tuple
  def digits(%CPF{digits: digits}), do: digits

  @doc """
  Returns a integer representation of the given cpf.

  ## Examples

      iex> 4_485_847_608 |> CPF.new() |> CPF.to_integer()
      4_485_847_608
  """
  @spec to_integer(t) :: pos_integer
  def to_integer(%CPF{digits: digits}) do
    0..10
    |> Enum.reduce(0, fn i, sum ->
      :math.pow(10, 10 - i) * elem(digits, i) + sum
    end)
    |> trunc()
  end

  @doc false
  def cast(cpf) do
    IO.warn("
    `CPF.cast/1` is deprecated and will be removed on version 1.0.0. Call `CPF.parse/1`
    ")

    case parse(cpf) do
      {:error, %CPF.ParsingError{reason: reason}} -> {:error, %CPF.CastingError{reason: reason}}
      ok -> ok
    end
  end

  @doc false
  def cast!(cpf) do
    IO.warn("
    `CPF.cast!/1` is deprecated and will be removed on version 1.0.0. Call `CPF.parse!/1`
    ")

    case cast(cpf) do
      {:ok, cpf} -> cpf
      {:error, exception} -> raise exception
    end
  end

  defp add_padding(digits) do
    padding = 11 - length(digits)

    if padding >= 0 do
      {:ok, add_padding(digits, padding)}
    else
      {:error, %CPF.ParsingError{reason: :too_long}}
    end
  end

  defp add_padding(digits, 0), do: digits

  defp add_padding(digits, padding) do
    add_padding([0 | digits], padding - 1)
  end

  defp skip_same_digits(digits) do
    if digits |> Enum.uniq() |> length() == 1 do
      {:error, %CPF.ParsingError{reason: :same_digits}}
    else
      {:ok, digits}
    end
  end

  defp verify_digits(digits) do
    cpf_digits = List.to_tuple(digits)
    {v1, v2} = calculate_verifier_digits(cpf_digits)
    {given_v1, given_v2} = extract_given_verifier_digits(cpf_digits)

    if v1 == given_v1 && v2 == given_v2 do
      {:ok, cpf_digits}
    else
      {:error, %CPF.ParsingError{reason: :invalid_verifier}}
    end
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

  defp to_digits(integer) do
    digits = Integer.digits(integer)
    padding = 11 - length(digits)

    if padding >= 0 do
      digits
      |> add_padding(padding)
      |> List.to_tuple()
    else
      raise ArgumentError, "it has more than 11 digits"
    end
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(cpf, opts) do
      formatted_cpf = cpf |> CPF.format() |> color(:atom, opts)
      concat(["#CPF<", formatted_cpf, ">"])
    end
  end

  defimpl String.Chars do
    @doc """
    Returns a `String.t` representation of the given `cpf`.

    ## Examples

        iex> "04485847608" |> CPF.new() |> to_string()
        "04485847608"
    """
    @spec to_string(CPF.t()) :: String.t()
    def to_string(cpf) do
      digits = CPF.digits(cpf)
      for i <- 0..10, into: "", do: digits |> elem(i) |> Kernel.to_string()
    end
  end
end
