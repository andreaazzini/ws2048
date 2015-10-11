defmodule Ws2048 do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    game_sup_children = [
      worker(Tty2048.Game, [4]),
      worker(Tty2048.Game.Watcher, [__MODULE__.Watcher])
    ]

    game_sup_opts = [strategy: :one_for_all, name: __MODULE__.GameSupervisor]

    children = [
      supervisor(__MODULE__.Endpoint, []),
      worker(__MODULE__.Repo, []),
      worker(__MODULE__.Move, []),
      supervisor(Supervisor, [game_sup_children, game_sup_opts], id: __MODULE__.Game)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    __MODULE__.Endpoint.config_change(changed, removed)
    :ok
  end
end
