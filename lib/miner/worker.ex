defmodule Blockchain.Miner.Worker do
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header
  alias Blockchain.Structures.Header
  alias Blockchain.Utilities.Serialization
  alias Blockchain.Verify.Tx
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Chain.Worker, as: Chain
  alias Blockchain.Keys.Mock

  use GenServer

  @limit_diff_target_zeroes <<0::256>>

  # Client API

  def start_link(_arg) do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def start() do
    GenServer.call(__MODULE__, :start)
  end

  def stop() do
    GenServer.call(__MODULE__, :stop)
  end

  def check() do
    GenServer.call(__MODULE__, :check)
  end

  def init(:ok) do
    state = %{miner: :stop, nonce: 0, block_candidate: nil}
    {:ok, state}
  end

  # Server callbacks

  def handle_call(:start, _from, %{miner: :stop} = state) do
    {:reply, :ok, %{state | miner: :working}}
  end

  def handle_call(:start, _from, %{miner: :working} = state) do
    {:reply, {:error, "Already working!"}, state}
  end

  def handle_call(:stop, _from, %{miner: :working} = state) do
    {:reply, :ok, %{state | miner: :stop}}
  end

  def handle_call(:stop, _from, %{miner: :stop} = state) do
    {:reply, {:error, "Already stopped"}, state}
  end

  def handle_call(:check, _from, state) do
    {:reply, state, state}
  end

  def candidate_block() do
    candidate_txs_list = Pool.take_and_remove_all_tx()

    valid_txs_list =
      Enum.reduce(candidate_txs_list, [], fn x, acc ->
        case Tx.verify(x) do
          true -> acc ++ [x]
          false -> acc
        end
      end)

    merkle_tree_hash = Chain.merkle_tree_hash(valid_txs_list)

    pub_key_miner = Mock.pub_key_miner()

    txs =
      if valid_txs_list == [] do
        [SignedTx.coinbase_tx(pub_key_miner)]
      else
        valid_txs_list
      end

    previous_block_hash = Chain.last_block() |> Serialization.hash()
    difficulty_target = 2
    txs_root_hash = merkle_tree_hash
    nonce = 1

    candidate_header = %Header{
      previous_hash: previous_block_hash,
      difficulty_target: difficulty_target,
      txs_root_hash: txs_root_hash,
      nonce: nonce
    }

    header = proof(candidate_header)
    Block.create(header, txs) |> Chain.add_block()
  end

  def proof(header) do
    hash_header = Serialization.hash(header)
    difficulty_target = header.difficulty_target
    <<max_zeroes::binary-size(difficulty_target), _::binary>> = @limit_diff_target_zeroes
    <<head::binary-size(difficulty_target), _::binary>> = hash_header

    if max_zeroes == head do
      header
    else
      new_header = %{header | nonce: header.nonce + 1}
      proof(new_header)
    end
  end
end
