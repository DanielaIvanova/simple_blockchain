defmodule Blockchain.Chain.Worker do
  @moduledoc """
  Worker with blocks in the chain and accounts with their tokens
  """
  alias Blockchain.Structures.Block
  alias Blockchain.Chain.ChainState
  alias Blockchain.Utilities.Serialization

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

  def clean() do
    GenServer.call(__MODULE__, :clean)
  end

  def all_blocks() do
    GenServer.call(__MODULE__, :all_blocks)
  end

  # Server callbacks

  def init(:ok) do
    blocks_list = [Block.genesis_block()]
    chain_state = %{}
    {:ok, %{blocks: blocks_list, accounts: chain_state}}
  end

  def handle_call(:get_state, _from, state) do
    last_block = state.blocks |> List.last()
    state_only_last_block = %{state | blocks: last_block}
    {:reply, state_only_last_block, state}
  end

  def handle_call({:add, block}, _from, state) do
    new_block_state = ChainState.get_block_state(block.txs)
    new_accounts = ChainState.get_chain_state(new_block_state, state.accounts)
    new_block_list = state.blocks ++ [block]
    {:reply, :ok, %{state | blocks: new_block_list, accounts: new_accounts}}
  end

  def handle_call(:last, _from, state) do
    blocks_list = state.blocks
    {:reply, List.last(blocks_list), state}
  end

  def handle_call({:get_balance, pub_key}, _from, state) do
    balance = state.accounts[pub_key]
    {:reply, balance, state}
  end

  def handle_call(:clean, _from, _state) do
    {:ok, new_state} = init(:ok)
    {:reply, :ok, new_state}
  end

  def handle_call(:all_blocks, _from, state) do
    {:reply, state.blocks, state}
  end

  def merkle_tree_hash(txs) do
    case txs do
      [] ->
        <<0::256>>

      _ ->
        hash_txs_list =
          for tx <- txs do
            {Serialization.hash(Serialization.tx_to_binary(tx)), Serialization.tx_to_binary(tx)}
          end

        hash_txs_list
        |> List.foldl(:gb_merkle_trees.empty(), fn k, v ->
          :gb_merkle_trees.enter(elem(k, 0), elem(k, 1), v)
        end)
        |> :gb_merkle_trees.root_hash()
    end
  end

  def chain_state_root_hash(chain_state) do
    hash_accounts_list =
      for {k, v} <- chain_state.accounts do
        {k, Serialization.tx_to_binary(v)}
      end

    merkle_tree_hash(hash_accounts_list)
  end
end
