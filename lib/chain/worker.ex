defmodule Blockchain.Chain.Worker do
  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header
  alias Blockchain.Chain.ChainState
  alias Blockchain.Miner.Worker, as: Miner

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

  def get_balance(pub_key) do
    GenServer.call(__MODULE__, {:get_balance, pub_key})
  end

  # Server callbacks

  def init(:ok) do
    blocks_list = [Block.genesis_block()]
    chain_state = %{}
    {:ok, %{blocks: blocks_list, chain_state: chain_state}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:add, block}, _from, state) do
    new_block_state = ChainState.get_block_state(block.txs)
    new_chain_state = ChainState.get_chain_state(new_block_state, state.chain_state)
    new_block_list = state.blocks ++ [block]
    {:reply, :ok, %{state | blocks: new_block_list, chain_state: new_chain_state}}
  end

  def handle_call(:last, _from, state) do
    blocks_list = state.blocks
    {:reply, List.last(blocks_list), state}
  end

  def handle_call({:get_balance, pub_key}, _from, state) do
    balance = state.chain_state[pub_key]
    {:reply, balance, state}
  end

  def merkle_tree_hash(txs) do
    if Enum.empty?(txs) == nil do
      <<0::256>>
    else
      tree =
        for tx <- txs do
          tx_bin = :erlang.term_to_binary(tx)
          {:crypto.hash(:sha256, tx_bin), tx_bin}
        end

      tree
      |> List.foldl(:gb_merkle_trees.empty(), fn node, tree ->
        :gb_merkle_trees.enter(elem(node, 0), elem(node, 1), tree)
      end)
    end
    |> :gb_merkle_trees.root_hash()
  end
end
