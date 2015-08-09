defmodule Ws2048.Endpoint do
  use Phoenix.Endpoint, otp_app: :ws2048

  socket "/socket", Ws2048.UserSocket

  plug Plug.Static,
    at: "/", from: :ws2048, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ws2048_key",
    signing_salt: "QlR1NJ7O"

  plug Ws2048.Router
end
