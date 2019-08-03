defmodule Mix.Tasks.Cpf.GenTest do
  use CPF.MixCase, async: false

  describe "run/1" do
    import Mix.Tasks.Cpf.Gen, only: [run: 1]

    test "generates valid random CPFs" do
      run([])

      assert_received {:mix_shell, :info, [cpf]}
      assert CPF.valid?(cpf)
    end

    test "accepts the count option" do
      count = Enum.random(1..100)
      run(["--count=#{count}"])

      {:messages, messages} = :erlang.process_info(self(), :messages)

      cpfs = for {:mix_shell, :info, [cpf]} <- messages, do: cpf

      assert length(cpfs) == count
      assert Enum.all?(cpfs, &CPF.valid?/1)
    end

    test "accepts the standard format" do
      run(["--format=standard"])

      assert_received {:mix_shell, :info, [cpf]}

      assert String.match?(cpf, ~r/[0-9]{3}\.[0-9]{3}\.[0-9]{3}-[0-9]{2}/)
    end

    test "accepts the digits format" do
      run(["--format=digits"])

      assert_received {:mix_shell, :info, [cpf]}
      assert String.match?(cpf, ~r/[0-9]{11}/)
    end

    test "accepts the integer format" do
      run(["--format=integer"])

      assert_received {:mix_shell, :info, [cpf]}
      assert String.match?(cpf, ~r/[1-9]{1}[0-9]{1,10}/)
    end

    test "fails with negative count" do
      assert catch_exit(run(["--count=-10"])) == {:shutdown, 1}
      {:mix_shell, :error, ["Invalid value `-10` for option --count"]}
    end

    test "fails with invalid count" do
      assert catch_exit(run(["--count=invalid"])) == {:shutdown, 1}
      {:mix_shell, :error, ["Invalid value for `--count`"]}
    end

    test "fails with invalid format" do
      assert catch_exit(run(["--format=invalid"])) == {:shutdown, 1}
      {:mix_shell, :error, ["Invalid value `invalid` for option --format"]}
    end
  end
end
