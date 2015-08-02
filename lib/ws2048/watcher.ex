defmodule Ws2048.Watcher do
  use GenEvent

  alias Tty2048.Game

  def init({%Game{} = game, _args}) do
    Ws2048.Endpoint.broadcast!("games:live", "move", game)
    {:ok, nil}
  end

  def handle_event(%Game{} = game, state) do
    Ws2048.Endpoint.broadcast!("games:live", "move", game)
    {:ok, state}
  end
end
