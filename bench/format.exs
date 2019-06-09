cpfs = [
  "00000000000",
  "11111111111",
  "22222222222",
  "33333333333",
  "44444444444",
  "55555555555",
  "66666666666",
  "77777777777",
  "88888888888",
  "99999999999",
  "56360667673",
  "21452716781",
  "78301234385",
  "45134085293",
  "92963835957",
  "97975234540",
  "83694332197",
  "29849713887",
  "48253729375"
]

# We can't run both at same time, because of the `CPF` name colision.
Benchee.run(
  %{
    # "Brcpfcnpj.format/1" => fn ->
    #   cpf = Enum.random(cpfs)
    #   input = %Cpf{number: cpf}
    #   Brcpfcnpj.cpf_format(input)
    # end
    "CPF.format/1" => fn ->
      CPF.format(cpfs |> Enum.random() |> CPF.new())
    end
  },
  warmup: 5,
  time: 10,
  memory_time: 1
)

# Generated cpf_bench app
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
# Estimated total run time: 16 s
#
# Benchmarking Brcpfcnpj.format/1...
#
# Name                         ips        average  deviation         median         99th %
# Brcpfcnpj.format/1       52.42 K       19.08 μs    ±62.20%          12 μs          45 μs
#
# Memory usage statistics:
#
# Name                       average  deviation         median         99th %
# Brcpfcnpj.format/1        10.00 KB    ±47.20%        5.55 KB       15.08 KB
# ============================================================================
# Generated cpf_bench app
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
# Estimated total run time: 16 s
#
# Benchmarking CPF.format/1...
#
# Name                   ips        average  deviation         median         99th %
# CPF.format/1      179.02 K        5.59 μs   ±384.40%           5 μs           7 μs
#
# Memory usage statistics:
#
# Name                 average  deviation         median         99th %
# CPF.format/1         3.09 KB     ±0.71%        3.08 KB        3.14 KB
