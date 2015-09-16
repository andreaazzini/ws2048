defmodule Ws2048.Move do
  use GenServer

  defstruct [up: 0, down: 0, left: 0, right: 0]

  @timeout 2_000

  def start_link() do
    GenServer.start_link(__MODULE__, %__MODULE__{}, name: __MODULE__)
  end

  def init(%__MODULE__{} = state) do
    Process.send_after(self(), :decided, @timeout)
    {:ok, state}
  end

  for side <- [:up, :down, :left, :right] do
    def unquote(side)() do
      GenServer.call(__MODULE__, unquote(side))
    end

    def handle_call(unquote(side), _, %__MODULE__{} = state) do
      old_side = Map.get(state, unquote(side))
      next_state = Map.put(state, unquote(side), old_side + 1)
      {:reply, next_state, next_state}
    end
  end

  def handle_info(:decided, %__MODULE__{} = state) do
    values =
      Map.from_struct(state)
      |> Map.values
    direction = Enum.max(values)
    if decided = unique?(values, direction) do
      decide_direction(state)
      |> Tty2048.Game.move
    end
    restart(decided)
  end

  defp decide_direction(%__MODULE__{} = state) do
    Enum.max_by(Map.from_struct(state), fn {_direction, n} -> n end)
    |> elem(0)
  end

  defp unique?(values, direction) do
    Enum.count(values, &(&1 == direction)) == 1
  end

  defp restart(decided) do
    Process.send_after(self(), :decided, @timeout)
    Ws2048.Endpoint.broadcast!("games:live", "timeout", %{decided: decided})
    {:noreply, %__MODULE__{}}
  end
end
