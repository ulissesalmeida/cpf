defmodule CpfTest do
  use ExUnit.Case
  doctest CPF

  test "greets the world" do
    assert CPF.hello() == :world
  end
end
