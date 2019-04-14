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
    # "Brcpfcnpj.cpf_valid?/1" => fn ->
    #   cpf = Enum.random(cpfs)
    #   input = %Cpf{number: cpf}
    #   Brcpfcnpj.cpf_valid?(input)
    # end
    "CPF.valid?/1" => fn ->
      CPF.valid?(cpfs |> Enum.random() |> String.to_integer())
    end
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
# CPF.valid?/1         3.25 KB    ±18.25%        2.74 KB        4.04 KB
