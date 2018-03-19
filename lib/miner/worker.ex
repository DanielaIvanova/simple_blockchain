defmodule Blockchain.Miner.Worker do
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header
  alias Blockchain.Structures.Header
  alias Blockchain.Utilities.Serialization
  alias Blockchain.Structures.Transaction
  alias Blockchain.Keys.Key
  alias Blockchain.Verify.Tx
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Chain.Worker, as: Chain

  use GenServer

  @coinbase_value 100

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

  def handle_call(:start, _from, state) do
    {:reply, :ok, %{state | miner: :working}}
  end

  def handle_call(:stop, _from, state) do
    {:reply, :ok, %{state | miner: :stop}}
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

    pub_key = Key.get_public_key()

    txs =
      if valid_txs_list == [] do
        [coinbase_tx(pub_key)]
      else
        valid_txs_list
      end

    previous_block_hash = Chain.last_block() |> Serialization.hash()
    difficulty_target = 2
    txs_root_hash = merkle_tree_hash
    nonce = 3

    candidate_header = %Header{
      previous_hash: previous_block_hash,
      difficulty_target: difficulty_target,
      txs_root_hash: txs_root_hash,
      nonce: nonce
    }

    Block.create(candidate_header, txs)
  end

  defp coinbase_tx(to_acc) do
    data = %Transaction{from_acc: nil, to_acc: to_acc, amount: @coinbase_value}
    %SignedTx{data: data, signature: nil}
  end
end
