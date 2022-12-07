# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2022-12-07
### Added
- Official support from Elixir 1.11 to Elixir 1.14. Thanks [@ayrat555](https://github.com/ayrat555)

### Removed

- Dropped support for Elixir versions below 1.11

## [1.1.0] - 2020-04-18

## Added

- Add official support to Elixir 1.10
- Add official support to Ecto 3.4 (cpf type in embed schemas)

## [1.0.0] - 2019-10-31

### Added
- Add `CPF.Ecto.Type` feature
- Add `CPF.Ecto.Changeset` feature

### Removed

- Removed support for wrong arguments in `CPF.valid?/1`
- Deleted `CPF.cast/1` and `CPF.cast!/1` functions
- Removed Elixir 1.5 support

## [0.8.1] - 2019-08-24
### Fix
- Mix tasks examples
- Visibility of the public mix tasks functions (they should be private)

## [0.8.0] - 2019-08-24
### Added
- Added `mix cpf.gen` and `mix cpf.check` tasks

## [0.7.1] - 2019-07-28
### Fix
- Fix documentation examples

## [0.7.0] - 2019-07-28
### Added
- `CPF.generate/0`

## [0.6.0] - 2019-07-07
### Added
- `CPF.flex/1`

## [0.5.1] - 2019-06-30

### Fixed
- Documentation examples

## [0.5.0] - 2019-06-30
### Added
- `to_string/1` and `CPF.to_integer/1`

### Deprecated
- Deprecated `CPF.cast/1` and `CPF.cast!/1` to favor `CPF.parse/1` and `CPF.parse!/1`

## [0.4.0] - 2019-06-16
### Added
- Add `CPF.cast/1` and `CPF.cast!/1` feature

### Deprecated
- Deprecated `CPF.valid?/1` with invalid types

## [0.3.0] - 2019-06-09
### Added
- Add `CPF.new/1` and `CPF.format/1` feature

### Deprecated
- Deprecated Elixir `1.5.0`

## [0.2.1] - 2019-04-29
### Fixed
- Make the CPF's Elixir version more forgiven

## [0.2.0] - 2019-04-21
### Added
- Add `CPF.valid?/1` for unformatted and formatted strings by [@lucaslvs](https://github.com/lucaslvs)

## [0.1.0] - 2019-04-14
### Added
- Add `CPF.valid?/1` for integers
