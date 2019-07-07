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

  describe "parse/1" do
    import CPF, only: [parse: 1]

    test "casts a valid integer CPF" do
      expected_cpf = CPF.new(4_485_847_608)

      assert {:ok, ^expected_cpf} = parse(4_485_847_608)
    end

    test "casts a valid string CPF" do
      expected_cpf = CPF.new("04485847608")

      assert {:ok, ^expected_cpf} = parse("04485847608")
    end

    test "casts a valid formatted CPF" do
      expected_cpf = CPF.new("04485847608")

      assert {:ok, ^expected_cpf} = parse("044.858.476-08")
    end

    test "returns error for too long CPF" do
      assert {:error, %CPF.ParsingError{reason: :too_long}} = parse("044858476080909090")
    end

    test "returns error for invalid digit verifier" do
      assert {:error, %CPF.ParsingError{reason: :invalid_verifier}} = parse("04485847607")
    end

    test "returns error for same digits" do
      assert {:error, %CPF.ParsingError{reason: :same_digits}} = parse("11111111111")
    end

    test "returns error for a invalid format" do
      assert {:error, %CPF.ParsingError{reason: :invalid_format}} = parse("044/858/476-08")
    end
  end

  describe "parse!" do
    import CPF, only: [parse!: 1]

    test "casts a valid integer CPF" do
      expected_cpf = CPF.new(4_485_847_608)

      assert ^expected_cpf = parse!(4_485_847_608)
    end

    test "casts a valid string CPF" do
      expected_cpf = CPF.new("04485847608")

      assert ^expected_cpf = parse!("04485847608")
    end

    test "casts a valid formatted CPF" do
      expected_cpf = CPF.new("04485847608")

      assert ^expected_cpf = parse!("044.858.476-08")
    end

    test "returns error for too long CPF" do
      assert_raise CPF.ParsingError, "too_long", fn ->
        parse!("044858476080909090")
      end
    end

    test "returns error for invalid digit verifier" do
      assert_raise CPF.ParsingError, "invalid_verifier", fn ->
        parse!("04485847607")
      end
    end

    test "returns error for same digits" do
      assert_raise CPF.ParsingError, "same_digits", fn ->
        parse!("11111111111")
      end
    end

    test "returns error for a invalid format" do
      assert_raise CPF.ParsingError, "invalid_format", fn ->
        parse!("044/858/476-08")
      end
    end
  end

  describe "to_string/1" do
    test "represents as String.t" do
      cpf = CPF.new("04485847608")

      assert to_string(cpf) == "04485847608"
    end
  end

  describe "to_integer/1" do
    import CPF, only: [to_integer: 1]

    test "represents as integer" do
      cpf = CPF.new(4_485_847_608)

      assert to_integer(cpf) == 4_485_847_608
    end
  end

  describe "flex/1" do
    import CPF, only: [flex: 1]

    test "returns a string only with the digits" do
      digits = CPF.flex("    04.4aaa.8*58().47cccddd6-08     ")

      assert digits == "04485847608"
    end
  end
end
