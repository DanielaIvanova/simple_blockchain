defmodule Blockchain.Chain.Worker do
  use GenServer

  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Utilities.Serialization

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

  def init(:ok) do
    hardcoded_header = %Header{previous_hash: <<0::256>>,
                               difficulty_target: 1,
                               nonce: 0}
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

  def candidate_block() do
    previous_block_hash = Serialization.hash(last_block())
    difficulty_target = 2
    # nonce
    candidate_header = %Header{previous_hash: previous_block_hash,
                               difficulty_target: difficulty_target,
                               nonce: 3}
    IO.puts "-- candidate_header---"
    IO.inspect candidate_header
    IO.puts "-- candidate_header---"
    candidate_txs_list = Pool.check_pool

  end


end
