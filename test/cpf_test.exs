defmodule CPFTest do
  use ExUnit.Case, async: true

  import CPF.Test.Support

  doctest CPF

  describe "new/1" do
    import CPF, only: [new: 1]

    test "initializes with integer" do
      assert new(4_485_847_608) == %CPF{digits: {0, 4, 4, 8, 5, 8, 4, 7, 6, 0, 8}}
    end

    test "initializes with string" do
      assert new("04485847608") == %CPF{digits: {0, 4, 4, 8, 5, 8, 4, 7, 6, 0, 8}}
    end

    test "raises with invalid number of digits" do
      assert_raise ArgumentError, "it has more than 11 digits", fn ->
        new("0448584760888989")
      end
    end
  end

  describe "valid?/1" do
    import CPF, only: [valid?: 1]

    test "returns true when CPF is valid" do
      # credo:disable-for-next-line
      assert valid?(044_858_476_08)
      assert valid?("044.858.476-08")
      assert valid?("04485847608")
    end

    @invalid_cpfs [
                    "invalid",
                    # credo:disable-for-next-line
                    123_456_789_10,
                    "123.456.789-10",
                    0,
                    # credo:disable-for-next-line
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

  describe "format/1" do
    import CPF, only: [format: 1]

    test "formats the given CPF" do
      assert "04485847608" |> CPF.new() |> format() == "044.858.476-08"
    end
  end
end
