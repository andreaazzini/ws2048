defmodule Ws2048.UserSocket do
  use Phoenix.Socket

  channel "games:*", Ws2048.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
