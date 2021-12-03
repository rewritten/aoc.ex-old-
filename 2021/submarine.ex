
defmodule Submarine do
  use GenServer

  import Complex, except: [parse: 1]

  defstruct loc: %Complex{}, aim: %Complex{re: 1}

  def new(opts \\ []), do: GenServer.start_link(__MODULE__, :ok, opts)

  def command(pid, cmd, line) do
    [a, b] = String.split(line)
    n = String.to_integer(b)

    case a do
      "forward" -> GenServer.cast(pid, {:forward, n})
      "up" -> GenServer.cast(pid, {cmd, %Complex{im: -n}})
      "down" -> GenServer.cast(pid, {cmd, %Complex{im: n}})
    end
  end

  @impl true
  def init(_), do: {:ok, %__MODULE__{}}

  @impl true
  def handle_cast({:move, n}, s), do: {:noreply, update_in(s.loc, &add(&1, n))}
  def handle_cast({:aim, n}, s), do: {:noreply, update_in(s.aim, &add(&1, n))}
  def handle_cast({:forward, n}, s), do: {:noreply, update_in(s.loc, &add(&1, mult(s.aim, n)))}

  @impl true
  def handle_call(:result, _, state), do: {:reply, state.loc.im * state.loc.re, state}
end
