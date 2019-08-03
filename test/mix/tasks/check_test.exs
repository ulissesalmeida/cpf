defmodule Mix.Tasks.Cpf.CheckTest do
  use CPF.MixCase, async: false

  describe "run/1" do
    import Mix.Tasks.Cpf.Check, only: [run: 1]

    test "returns valid when all CPFs are valid" do
      run(Enum.take(cpfs(), 10))

      assert_received {:mix_shell, :info, ["valid"]}
    end

    test "returns invalid when one CPF is invalid" do
      cpfs = Enum.take(cpfs(), 10) ++ ["invalidcpf"]

      assert catch_exit(run(cpfs)) == {:shutdown, 1}
      assert_received {:mix_shell, :error, ["invalid"]}
    end

    test "accepts the flex option" do
      run(Enum.take(cpfs(), 10) ++ ["194.925.115.25", "--flex"])

      assert_received {:mix_shell, :info, ["valid"]}
    end

    test "fails with invalid flex option" do
      cpfs = Enum.take(cpfs(), 10) ++ ["--flex=invalid"]

      assert catch_exit(run(cpfs)) == {:shutdown, 1}
      assert_received {:mix_shell, :error, ["Invalid value for `--flex`"]}
    end

    defp cpfs,
      do:
        Stream.repeatedly(fn ->
          CPF.generate() |> to_string
        end)
  end
end
