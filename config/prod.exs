use Mix.Config

config :ws2048, Ws2048.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "http", host: "ws2048.herokuapp.com", port: 80],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :ws2048, Ws2048.Repo,
  adapter: Ecto.Adapters.MySQL,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

config :logger, level: :info
