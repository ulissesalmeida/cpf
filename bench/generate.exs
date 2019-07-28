Benchee.run(
  %{
    "Brcpfcnpj.cpf_generate/0" => fn ->
      cpf = Brcpfcnpj.cpf_generate()
      input = %Cpf{number: cpf}
      Brcpfcnpj.cpf_valid?(input) or raise "Invalid CPF!"
    end
    # "CPF.generate/0" => fn ->
    #   CPF.generate() |> to_string() |> CPF.valid?() or raise "Invalid CPF!"
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
# Elixir 1.9.0
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
# Benchmarking CPF.generate/0...
#
# Name                     ips        average  deviation         median         99th %
# CPF.generate/0      127.90 K        7.82 μs   ±240.81%           7 μs          11 μs
#
# Memory usage statistics:
#
# Name                   average  deviation         median         99th %
# CPF.generate/0         5.62 KB     ±3.17%        5.64 KB           6 KB
#
#
# Benchmarking Brcpfcnpj.cpf_generate/0...
#
# Name                             ips        average  deviation         median         99th %
# Brcpfcnpj.cpf_generate/0       21.50 K       46.51 μs    ±19.49%          45 μs          82 μs
#
# Memory usage statistics:
#
# Name                           average  deviation         median         99th %
# Brcpfcnpj.cpf_generate/0        28.54 KB     ±0.23%       28.54 KB       28.70 KB
