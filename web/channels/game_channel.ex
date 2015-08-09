defmodule Ws2048.GameChannel do
  use Phoenix.Channel

  alias Ws2048.Move

  def join("games:live", message, socket) do
    Process.flag(:trap_exit, true)
    send(self, :peek_grid)
    {:ok, socket}
  end

  def join("games:" <> _private_game, _message, _socket) do
    :ignore
  end

  def terminate(reason, socket) do
    :ok
  end

  def handle_info(:peek_grid, socket) do
    {_, game} = Tty2048.Game.peek()
    push socket, "grid", game
    {:noreply, socket}
  end

  def handle_in("move:up", _msg, socket) do
    state = Move.up()
    broadcast! socket, "move:up", state
    {:noreply, socket}
  end

  def handle_in("move:down", _msg, socket) do
    state = Move.down()
    broadcast! socket, "move:down", state
    {:noreply, socket}
  end

  def handle_in("move:left", _msg, socket) do
    state = Move.left()
    broadcast! socket, "move:left", state
    {:noreply, socket}
  end

  def handle_in("move:right", _msg, socket) do
    state = Move.right()
    broadcast! socket, "move:right", state
    {:noreply, socket}
  end
end
