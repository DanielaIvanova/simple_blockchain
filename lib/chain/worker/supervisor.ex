defmodule Blockchain.Chain.Worker.Supervisor do
  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children = [
      Blockchain.Chain.Worker
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
