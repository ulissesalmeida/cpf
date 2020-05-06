# CPF

A library to work with CPFs.

[![Hex pm](https://img.shields.io/hexpm/v/cpf.svg?style=flat)](https://www.hex.pm/packages/cpf)
[![CircleCI](https://circleci.com/gh/ulissesalmeida/cpf/tree/master.svg?style=svg)](https://circleci.com/gh/ulissesalmeida/cpf/tree/master)
[![Coverage Status](https://coveralls.io/repos/github/ulissesalmeida/cpf/badge.svg?branch=master)](https://coveralls.io/github/ulissesalmeida/cpf?branch=master)

CPF is an acronym for "Cadastro de Pessoa Físicas," it's a unique number
associated to a person that the Brazilian government maintains. With this
number, it is possible to check or retrieve information about a person.

This library provides a validation that checks if the number is a valid CPF
number. The CPF has check digit algorithm is similar to
[`ISBN 10`](https://en.wikipedia.org/wiki/Check_digit#ISBN_10), you can check
the details in Portuguese [here](https://pt.wikipedia.org/wiki/Cadastro_de_pessoas_f%C3%ADsicas#C%C3%A1lculo_do_d%C3%ADgito_verificador).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cpf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cpf, "~> 1.0"}
  ]
end
```

## Quick Start

You can verify if a CPF is valid by calling the function `CPF.valid?/1`:

```elixir
iex> CPF.valid?(563_606_676_73)
true

iex> CPF.valid?(563_606_676_72)
false

iex> CPF.valid?("563.606.676-73")
true

iex> CPF.valid?("563.606.676-72")
false

iex> CPF.valid?("56360667673")
true

iex> CPF.valid?("56360667672")
false
```

## Parsing and Storing CPFs

If you want to store CPF as integer or as `String.t`, this library have
you covered. You can do:

```elixir
iex> "044.858.476-08" |> CPF.parse!() |> CPF.to_integer()
4485847608

iex> "044.858.476-08" |> CPF.parse!() |> to_string()
"04485847608"
```

Storing CPF as strings are easier for a human to read since the 0 padding digits
are there. Meanwhile, storing as integers will allow you have better performance
in CPF lookups.

The `CPF.parse/1` and `CPF.parse!/1` returns you the CPF value wrapped in a
custom type with explicit digits.

```elixir
iex> CPF.parse("044.858.476-08")
{:ok, #CPF<"044.858.476-08">}

iex> CPF.parse("044.858.476-07")
{:error, %CPF.ParsingError{reason: :invalid_verifier}}

iex> CPF.parse!("044.858.476-08")
#CPF<"044.858.476-08">

iex> CPF.parse!("044.858.476-07")
** (CPF.ParsingError) invalid verifier
```

With the casted CPF in hands, you can use `CPF.format/1`, `CPF.to_integer/1` and
`to_string/1`.

## CPF Formatting

If you have a valid CPF strings or integer in hands, you can use `CPF.new/1` and
in sequence call `CPF.format/1`:

```elixir
iex> 4485847608 |> CPF.new() |> CPF.format()
"044.858.476-08"

iex> "04485847608" |> CPF.new() |> CPF.format()
"044.858.476-08"
```

The `CPF.format/1` expects the input be wrapped in the CPF type. Remember, only
use `CPF.new` with valid CPFs, no other checks are done there. If you need some
validation, use `CPF.parse/1`.

## Generating random CPFs for testing

You can generate valid CPF numbers by using `CPF.generate/0`:

```elixir
iex> CPF.generate()
#CPF<671.835.731-68>

iex> CPF.generate() |> to_string()
"67183573168"

iex> CPF.generate() |> CPF.to_integer()
67183573168

iex> CPF.generate() |> CPF.format()
"671.835.731-68"
```

After you generate the CPF, you can turn the CPF into a formatted string, or
convert to a string digits, or convert to integer.

## Flexibilizing the CPF validation

You can use `CPF.flex/1` when you only care if the user has provided the
correct number before any validation or parsing. For example:

```elixir
iex> "04.4.8*58().476-08" |> CPF.flex() |> CPF.valid?()
true

iex> "04.4.8*58().476-08" |> CPF.flex() |> CPF.parse!() |> CPF.format()
"044.858.476-08"
```

It can be useful to take a user's dirty input and format it.

## Command line

You can generate random valid CPFs with:

```shell
$ mix cpf.gen
194.925.115-25

$ mix cpf.gen --format=digits --count=2
19492511525
65313188640
```

You can also check if CPF are valid with:

```shell
$ mix cpf.check 194.925.115-25
valid
```

Run `mix help cpf.gen` and `mix help cpf.check` to read a further explanation
about the commands available options.

## Ecto Integration

If you have `ecto` installed in your application, you can use the module
`CPF.Ecto.Type` or `CPF.Ecto.Changeset` to cast and validate CPF fields.


### Using `CPF.Ecto.Type`

If you like the strictness of types you can user `CPF.Ecto.Type` functions to
define in your schema the CPF field type. For example:

```elixir
defmodule MyApp.Profile do
  use Ecto.Schema

  import Ecto.Changeset
  # Import the parameterized type function
  import CPF.Ecto.Type

  schema "profiles" do
    # use `cpf_type/1` in the field type definition
    field :cpf, cpf_type(:string)
  end

  def new(enum \\ %{}), do: struct!(__MODULE__, enum)

  def changeset(profile, params), do: cast(profile, params, __schema__(:fields))
end
```

It will prevent any attempt to insert an invalid CPF when using your
schema module. For example:

```elixir
{:error, changeset} =
  Profile.new()
  |> Profile.changeset(%{cpf: "abilidebob"})
  |> MyApp.Repo.insert()

{"is invalid", [reason: :invalid_format]} = Keyword.get(changeset.errors, :cpf)
```

Note: it will also prevent queries with invalid CPFs by raising casting error.
You might need workaround it if you want to display an empty result with invalid
CPFs. For example:

```elixir
if CPF.valid?(cpf) do
  query = from p in Profile, where: p.cpf == ^cpf
  Repo.all(query)
else
  []
end
```

If you're working in a search form, you might want to create a
`search_form_changeset` and validate the search inputs before querying the
database.

### Using `CPF.Ecto.Changeset`

If you don't want use type in your CPF fields, you can use
`CPF.Ecto.Changeset.validate_cpf/2` function to validate a field in your
changeset. Example:

```elixir
CPF.Ecto.Changeset.validate_cpf(changeset, :cpf)
```

Using this approach you need manually cast the CPF field to store in uniform
way. As example, you can do that using the `Ecto.Change.prepare_changes/1`.
Example:

```elixir
changeset
|> CPF.Ecto.Changeset.validate_cpf(:cpf)
|> Ecto.Changeset.prepare_changes(fn changeset ->
  if input = Ecto.Changeset.get_change(changeset, :cpf) do
    string_cpf = input |> CPF.parse!() |> to_string()
    Ecto.Changeset.put_change(changeset, :cpf, string_cpf)
  else
    changeset
  end
end)
```

The `prepare_changes/2` will be called after the validation and before insert or
update in the repository. It gives the developer the opportunity to transform
the CPF value in any way they want.

## Why not other libraries?

This library runs 3 times faster and consume 3 times less memory and work with
primitive types, no extra struct is necessary.

## Docs

The docs can be found at [https://hexdocs.pm/cpf](https://hexdocs.pm/cpf).
