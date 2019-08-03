defmodule Mix.Tasks.Cpf.Helpers do
  @moduledoc false

  def error_exit(error_msg) do
    Mix.shell().error(error_msg)
    exit({:shutdown, 1})
  end
end
