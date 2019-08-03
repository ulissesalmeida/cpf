defmodule Mix.Tasks.Cpf.Gen do
  @moduledoc """
  Generates a valid random CPF.

  ## Options

    - `--format`, formats the CPF with the specified format:
      * `standard` (default), formats the CPF using dots and slashes.
      * `digits`, only display the CPF digits
      * `integer`, returns the CPF as integer number

    - `--count`, generates `count` times random CPFs

  ## Examples

      $ mix cpf.gen
      194.925.115-25

      $ mix cpf.gen --format=digits
      19492511525

      $ mix cpf.gen --format=integer
      4485847608

      $ mix cpf.gen --format=digits --count=2
      19492511525
      65313188640
  """
  @shortdoc "Generates a random CPF"

  @options [
    aliases: [f: :format, c: :count],
    strict: [format: :string, count: :integer]
  ]

  use Mix.Task
  import Mix.Tasks.Cpf.Helpers

  @impl Mix.Task
  def run(args) do
    args
    |> OptionParser.parse(@options)
    |> generate()
  end

  def generate({opts, _, []}) do
    with {:ok, formatter} <- format(opts[:format]),
         {:ok, count} <- count(opts[:count]) do
      for _i <- 1..count do
        CPF.generate()
        |> formatter.()
        |> Mix.shell().info()
      end
    else
      {:error, {option, value}} ->
        error_exit("Invalid value `#{value}` for option --#{option}")
    end
  end

  def generate({_, _, invalids}) do
    {opt, _value} = List.first(invalids)
    error_exit("Invalid value for `#{opt}`")
  end

  def format(opt) when opt in [nil, "standard"], do: {:ok, &CPF.format/1}
  def format("digits"), do: {:ok, &to_string/1}
  def format("integer"), do: {:ok, &(&1 |> CPF.to_integer() |> to_string())}
  def format(option), do: {:error, {:format, option}}

  def count(nil), do: {:ok, 1}
  def count(n) when n > 0, do: {:ok, n}
  def count(n), do: {:error, {:count, n}}
end
