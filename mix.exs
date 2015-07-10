defmodule EctoPlay.Mixfile do
  use Mix.Project

  def project do
    [app: :ecto_play,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [mod: {EctoPlay, []},
     applications: [:postgrex, :ecto, :logger]]
  end

  defp deps do
    [
      { :postgrex, "~> 0.8.0" },
      { :ecto, "~> 0.11.3" },
    ]
  end
end
