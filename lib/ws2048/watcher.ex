defmodule Ws2048.Watcher do
  use GenEvent

  alias Tty2048.Game

  import Ws2048.Endpoint, only: [broadcast!: 3]

  def init({%Game{} = game, _args}) do
    broadcast! "games:live", "move", game
    {:ok, nil}
  end

  def handle_event({:moved, %Game{} = game}, state) do
    broadcast! "games:live", "move", game
    {:ok, state}
  end

  def handle_event({:game_over, _game}, state) do
    Ws2048.Move.game_over
    {:ok, state}
  end
end
