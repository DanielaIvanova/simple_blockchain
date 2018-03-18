defmodule Blockchain.Application do
  use Application

  def start(_type, _args) do
    children = [
      Blockchain.Pool.Worker.Supervisor,
      Blockchain.Chain.Worker.Supervisor,
      Blockchain.Miner.Worker.Supervisor
    ]

    opts = [strategy: :one_for_one, name: Blockchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
