use Mix.Config

config :ecto_play, EctoPlay.Repo,
    url: "ecto://postgres:password@localhost/ecto_play",
    adapter: Ecto.Adapters.Postgres
