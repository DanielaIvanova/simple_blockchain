defmodule Blockchain.Pool.Worker do
  @moduledoc """
  Worker with transactions in the pool
  """
  use GenServer

  # Client API

  def start_link(_ar) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def add_tx(tx) do
    GenServer.call(__MODULE__, {:add_tx, tx})
  end

  def check_pool() do
    GenServer.call(__MODULE__, :check)
  end

  def take_and_remove_all_tx() do
    GenServer.call(__MODULE__, :take_and_remove_all_tx)
  end

  # Server callbacks

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:add_tx, tx}, _from, pool) do
    new_pool = pool ++ [tx]
    {:reply, :ok, new_pool}
  end

  def handle_call(:check, _from, pool) do
    {:reply, pool, pool}
  end

  def handle_call(:take_and_remove_all_tx, _form, pool) do
    {:reply, pool, []}
  end
end
