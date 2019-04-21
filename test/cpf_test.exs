defmodule CPFTest do
  use ExUnit.Case, async: true

  import CPF.Test.Support

  doctest CPF

  describe "valid?/1" do
    import CPF, only: [valid?: 1]

    test "returns true when CPF is valid" do
      assert valid?(044_858_476_08)
      assert valid?("044.858.476-08")
      assert valid?("04485847608")
    end

    @invalid_cpfs [
                    "invalid",
                    123_456_789_10,
                    "123.456.789-10",
                    0,
                    123_456_789_09.0,
                    "123456789090"
                  ] ++ Enum.map(1..9, &to_11_digits/1)

    for input <- @invalid_cpfs do
      @input input
      test "returns false for #{@input}" do
        refute valid?(@input)
      end
    end
  end
end
