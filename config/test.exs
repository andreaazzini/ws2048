use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ws2048, Ws2048.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :ws2048, Ws2048.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "ws2048_test",
  pool: Ecto.Adapters.SQL.Sandbox
