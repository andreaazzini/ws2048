defmodule Ws2048 do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Ws2048.Endpoint, []),
      worker(Ws2048.Repo, []),
      worker(Ws2048.Move, []),
      worker(Tty2048.Game, [4]),
      worker(Tty2048.Game.Watcher, [Ws2048.Watcher])
    ]

    opts = [strategy: :one_for_one, name: Ws2048.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Ws2048.Endpoint.config_change(changed, removed)
    :ok
  end
end
