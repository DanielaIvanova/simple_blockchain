defmodule Blockchain.Miner.Worker.Supervisor do
  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Blockchain.Miner.Worker
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
