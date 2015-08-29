defmodule Ws2048.Move do
  use GenServer

  defstruct [:up, :down, :left, :right]

  def start_link() do
    GenServer.start_link(__MODULE__, reset(), name: __MODULE__)
  end

  def init(%__MODULE__{} = state) do
    Process.send_after(self(), :decided, 2_000)
    {:ok, state}
  end

  def up() do
    GenServer.call(__MODULE__, :up)
  end

  def down() do
    GenServer.call(__MODULE__, :down)
  end

  def left() do
    GenServer.call(__MODULE__, :left)
  end

  def right() do
    GenServer.call(__MODULE__, :right)
  end

  def handle_info(:decided, %__MODULE__{} = state) do
    values = Map.from_struct(state) |> Map.values()
    direction = Enum.max(values)
    if unique_move?(values, direction) do
      decide_direction(state) |> Tty2048.Game.move()
      Ws2048.Endpoint.broadcast!("games:live", "timeout", %{decided: true})
    else
      Ws2048.Endpoint.broadcast!("games:live", "timeout", %{decided: false})
    end
    restart()
  end

  def handle_call(:up, _, %__MODULE__{up: up} = state) do
    new_state = %{state | up: up + 1}
    {:reply, new_state, new_state}
  end

  def handle_call(:down, _, %__MODULE__{down: down} = state) do
    new_state = %{state | down: down + 1}
    {:reply, new_state, new_state}
  end

  def handle_call(:left, _, %__MODULE__{left: left} = state) do
    new_state = %{state | left: left + 1}
    {:reply, new_state, new_state}
  end

  def handle_call(:right, _, %__MODULE__{right: right} = state) do
    new_state = %{state | right: right + 1}
    {:reply, new_state, new_state}
  end

  defp reset(),
    do: %__MODULE__{up: 0, down: 0, left: 0, right: 0}

  defp restart() do
    Process.send_after(self(), :decided, 2_000)
    {:noreply, reset()}
  end

  defp decide_direction(%__MODULE__{} = state) do
    Enum.max_by(Map.from_struct(state), fn {_direction, n} -> n end)
    |> elem(0)
  end

  defp unique_move?(values, direction),
    do: Enum.count(values, &(&1 == direction)) == 1
end
