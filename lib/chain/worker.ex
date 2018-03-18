defmodule Blockchain.Chain.Worker do

  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header

  use GenServer

  # Client API

  def start_link(_arg) do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  def add_block(block) do
    GenServer.call(__MODULE__, {:add, block})
  end

  def last_block() do
    GenServer.call(__MODULE__, :last)
  end

  # Server callbacks

  def init(:ok) do
    hardcoded_header = %Header{previous_hash: <<0::256>>, difficulty_target: 1, nonce: 0}
    herdcoded_tx_list = []
    hardcoded_block = %Block{header: hardcoded_header, txs: herdcoded_tx_list}
    state = [hardcoded_block]
    {:ok, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add, block}, _from, state) do
    new_state = state ++ [block]
    {:reply, new_state, new_state}
  end

  def handle_call(:last, _from, state) do
    {:reply, List.last(state), state}
  end

end
