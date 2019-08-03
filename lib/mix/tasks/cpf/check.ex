defmodule Mix.Tasks.Cpf.Check do
  @moduledoc """
  Checks if the given CPFs are valid.

  ## Options

    - `--flex`, only check the CPF digits and ignore any extra character

  ## Examples

      $ mix cpf.check 194.925.115-25
      valid

      $ mix cpf.check 194.925.115-24
      invalid

      $ mix cpf.check 194.925.115-25 19492511525
      valid

      $ mix cpf.check 194.925.115.25
      invalid

      $ mix cpf.check 194.925.115.25 --flex
      valid
  """

  @shortdoc "Checks if the given CPF is valid"

  @options [
    aliases: [f: :flex],
    strict: [flex: :boolean]
  ]

  use Mix.Task
  import Mix.Tasks.Cpf.Helpers

  @impl Mix.Task
  def run(args) do
    args
    |> OptionParser.parse(@options)
    |> validate()
  end

  defp validate({opts, inputs, []}) do
    if Enum.all?(inputs, &valid?(&1, opts[:flex])) do
      Mix.shell().info("valid")
    else
      error_exit("invalid")
    end
  end

  defp validate({_, _, invalids}) do
    {opt, _} = List.first(invalids)
    error_exit("Invalid value for `#{opt}`")
  end

  def valid?(input, flex?) do
    if flex? do
      input |> CPF.flex() |> CPF.valid?()
    else
      CPF.valid?(input)
    end
  end
end
