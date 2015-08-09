defmodule Ws2048.Mixfile do
  use Mix.Project

  def project do
    [app: :ws2048,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {Ws2048, []},
     applications: [:phoenix, :phoenix_html, :cowboy,
                    :logger, :phoenix_ecto, :mariaex]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [{:phoenix, "~> 0.15"},
     {:phoenix_ecto, "~> 0.8"},
     {:mariaex, ">= 0.0.0"},
     {:phoenix_html, "~> 1.4"},
     {:phoenix_live_reload, "~> 0.5", only: :dev},
     {:cowboy, "~> 1.0"},
     {:tty2048, github: "lexmag/tty2048"}]
  end
end
