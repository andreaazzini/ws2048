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
    if Enum.count(values, &(&1 == direction)) == 1,
      do: decide_direction(state) |> Tty2048.Game.move()
    restart()
  end

  def handle_call(:up, _, %__MODULE__{up: up} = state) do
    {:reply, state, %{state | up: up + 1}}
  end

  def handle_call(:down, _, %__MODULE__{down: down} = state) do
    {:reply, state, %{state | down: down + 1}}
  end

  def handle_call(:left, _, %__MODULE__{left: left} = state) do
    {:reply, state, %{state | left: left + 1}}
  end

  def handle_call(:right, _, %__MODULE__{right: right} = state) do
    {:reply, state, %{state | right: right + 1}}
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
end
