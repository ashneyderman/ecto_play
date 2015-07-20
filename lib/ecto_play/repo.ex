defmodule EctoPlay.Repo do
  require Logger
  use Ecto.Repo, otp_app: :ecto_play

  def log(arg, fun) do
    Logger.debug "query: #{inspect arg}"
    fun.()
  end

end