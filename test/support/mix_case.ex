defmodule CPF.MixCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  setup _tags do
    Mix.shell(Mix.Shell.Process)

    on_exit(fn ->
      Mix.shell(Mix.Shell.IO)
    end)

    :ok
  end
end
