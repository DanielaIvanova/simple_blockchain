defmodule Blockchain.Pool.Worker do
  use GenServer

  # Client API
  def start_link(_ar) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def add_tx(tx) do
    GenServer.call(__MODULE__, {:add_tx, tx})
  end

  def check_pool() do
    GenServer.call(__MODULE__, :check)
  end

  # Server callback
  def handle_call({:add_tx, tx}, _from, pool) do
    {:ok, sign_tx} = tx
    new_pool = pool ++ [sign_tx]
    {:reply, :ok, new_pool}
  end

  def handle_call(:check, _from, pool) do
    {:reply, pool, pool}
  end
end
