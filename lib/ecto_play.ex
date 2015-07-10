defmodule EctoPlay do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    tree = [worker(EctoPlay.Repo, [])]
    opts = [name: EctoPlay.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end
end
