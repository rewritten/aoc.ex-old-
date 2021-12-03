Mix.install([:complex])

Code.require_file("2021/submarine.ex")

{:ok, simple_submarine} = Submarine.new()
{:ok, aiming_submarine} = Submarine.new()

for line <- File.stream!("2021/2.txt") do
  Submarine.command(simple_submarine, :move, line)
  Submarine.command(aiming_submarine, :aim, line)
end

simple_submarine
|> GenServer.call(:result)
|> IO.inspect(label: "part 1")

aiming_submarine
|> GenServer.call(:result)
|> IO.inspect(label: "part 2")
