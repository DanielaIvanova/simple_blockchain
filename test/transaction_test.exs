defmodule TransactionTest do
  use ExUnit.Case

  alias Blockchain.Chain.Worker, as: Chain
  alias Blockchain.Miner.Worker, as: Miner
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Keys.Mock
  alias Blockchain.Structures.Transaction
  alias Blockchain.Structures.SignedTx

  test "add transaction in a block into the chain" do
    Chain.clean()
    Pool.take_and_remove_all_tx()
    private_key_miner = Mock.private_key_miner()
    pub_key_miner = Mock.pub_key_miner()

    private_key_1 = Mock.private_key_1()
    pub_key_1 = Mock.pub_key_1()

    tx = Transaction.create(pub_key_miner, pub_key_1, 130)
    signed_tx = SignedTx.sign_tx(tx, private_key_miner)

    assert :ok = Pool.add_tx(signed_tx)

    assert :ok = Miner.mine_one_block()
    assert :ok = Miner.mine_one_block()
    assert :ok = Miner.mine_one_block()

    state = Chain.get_state()

    assert 170 == state.accounts[pub_key_miner]
    assert 130 == state.accounts[pub_key_1]
  end
end
