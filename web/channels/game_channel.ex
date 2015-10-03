defmodule Ws2048.GameChannel do
  use Phoenix.Channel

  def join("games:live", _, socket) do
    send(self, :peek_grid)
    {:ok, socket}
  end
  def join("games:" <> _private_game, _, _socket), do: :ignore

  def terminate(_reason, _socket), do: :ok

  def handle_info(:peek_grid, socket) do
    {_, game} = Tty2048.Game.peek
    push socket, "grid", game
    {:noreply, socket}
  end

  for side <- ~w(up down left right) do
    fun_name = String.to_atom(side)
    def handle_in("move:" <> unquote(side), _msg, socket) do
      state = Ws2048.Move.unquote(fun_name)
      broadcast! socket, "move:" <> unquote(side), state
      {:noreply, socket}
    end
  end
end
