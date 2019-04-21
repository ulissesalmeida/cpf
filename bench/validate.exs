cpfs = [
  "000.000.000-00",
  "111.111.111-11",
  "222.222.222-22",
  "333.333.333-33",
  "444.444.444-44",
  "555.555.555-55",
  "666.666.666-66",
  "777.777.777-77",
  "888.888.888-88",
  "999.999.999-99",
  "563.606.676-73",
  "214.527.167-81",
  "783.012.343-85",
  "451.340.852-93",
  "929.638.359-57",
  "979.752.345-40",
  "836.943.321-97",
  "298.497.138-87",
  "482.537.293-75"
]

# We can't run both at same time, because of the `CPF` name colision.
Benchee.run(
  %{
    # "Brcpfcnpj.cpf_valid?/1" => fn ->
    #   cpf = Enum.random(cpfs)
    #   input = %Cpf{number: cpf}
    #   Brcpfcnpj.cpf_valid?(input)
    # end
    "CPF.valid?/1" => fn ->
      CPF.valid?(cpfs |> Enum.random())
    end
    # "CPF.valid_with_regex?/1" => fn ->
    #   CPF.valid_with_regex?(cpfs |> Enum.random())
    # end
  },
  warmup: 5,
  time: 10,
  memory_time: 1
)

# Operating System: macOS
# CPU Information: Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
# Number of Available Cores: 12
# Available memory: 16 GB
# Elixir 1.8.1
# Erlang 21.1
#
# Benchmarking Brcpfcnpj.cpf_valid?/1...
#
# Name                             ips        average  deviation         median         99th %
# Brcpfcnpj.cpf_valid?/1       67.44 K       14.83 μs   ±109.81%          11 μs          31 μs
#
# Memory usage statistics:
#
# Name                           average  deviation         median         99th %
# Brcpfcnpj.cpf_valid?/1         8.93 KB    ±40.36%        5.55 KB       12.84 KB
#
# Benchmarking CPF.valid?/1...
#
# Name                   ips        average  deviation         median         99th %
# CPF.valid?/1      190.94 K        5.24 μs   ±393.50%           5 μs           8 μs
#
# Memory usage statistics:
#
# Name                 average  deviation         median         99th %
# CPF.valid?/1         3.25 KB    ±18.25%        2.74 KB        4.04 KB\\

# =======================================================================
# Results Regex vs Binary Pattern Matching
# =======================================================================

# Operating System: macOS
# CPU Information: Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
# Number of Available Cores: 12
# Available memory: 16 GB
# Elixir 1.8.1
# Erlang 21.1
#
# Benchmark suite executing with the following configuration:
# warmup: 5 s
# time: 10 s
# memory time: 1 s
# parallel: 1
# inputs: none specified
# Estimated total run time: 32 s
#
# Benchmarking CPF.valid?/1...
# Benchmarking CPF.valid_with_regex?/1...
#
# Name                              ips        average  deviation         median         99th %
# CPF.valid?/1                 166.92 K        5.99 μs   ±409.47%           6 μs           9 μs
# CPF.valid_with_regex?/1      104.75 K        9.55 μs   ±118.38%           9 μs          15 μs
#
# Comparison:
# CPF.valid?/1                 166.92 K
# CPF.valid_with_regex?/1      104.75 K - 1.59x slower +3.56 μs
#
# Memory usage statistics:
#
# Name                            average  deviation         median         99th %
# CPF.valid?/1                    3.79 KB    ±15.65%        3.29 KB        4.59 KB
# CPF.valid_with_regex?/1         4.79 KB    ±12.36%        4.29 KB        5.59 KB
#
# Comparison:
# CPF.valid?/1                    3.29 KB
# CPF.valid_with_regex?/1         4.79 KB - 1.26x memory usage +1.00 KB
