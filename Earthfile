VERSION 0.6

all-test:
  BUILD \
    --build-arg ELIXIR_VERSION=1.14.1-alpine \
    --build-arg ELIXIR_VERSION=1.13.2-alpine \
    --build-arg ELIXIR_VERSION=1.12.3-alpine \
    --build-arg ELIXIR_VERSION=1.11.4-alpine \
    +test

test:
  FROM +elixir

  COPY --dir test ./

  RUN mix unit_test

elixir:
  ARG ELIXIR_VERSION=1.14.1-alpine
  FROM elixir:$ELIXIR_VERSION

  COPY mix.exs mix.lock .formatter.exs ./

  RUN mix local.rebar --force
  RUN mix local.hex --force

  ENV MIX_ENV test

  RUN mix deps.get

  RUN mix deps.compile

  COPY --dir lib ./

  RUN mix compile --warning-as-errors
