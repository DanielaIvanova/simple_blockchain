defmodule ValidationTxTest do
  use ExUnit.Case

  alias Blockchain.Verify.Tx
  alias Blockchain.Keys.Mock
  alias Blockchain.Structures.Transaction
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Chain.Worker, as: Chain
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Miner.Worker, as: Miner

  test "validate valid transaction" do
    Chain.clean()
    private_key_miner = Mock.private_key_miner()
    pub_key_miner = Mock.pub_key_miner()

    private_key_1 = Mock.private_key_1()
    pub_key_1 = Mock.pub_key_1()

    tx = Transaction.create(pub_key_miner, pub_key_1, 30)
    signed_tx = SignedTx.sign_tx(tx, private_key_miner)

    assert :ok = Pool.add_tx(signed_tx)
    assert :ok = Miner.mine_one_block()
    assert Tx.verify(signed_tx) == true
  end

  test "validate invalid transaction 1" do
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
    assert Tx.verify(signed_tx) == false
  end

  test "validate invalid transaction 2" do
    Chain.clean()
    Pool.take_and_remove_all_tx()
    private_key_miner = Mock.private_key_miner()
    pub_key_miner = Mock.pub_key_miner()

    private_key_1 = Mock.private_key_1()
    pub_key_1 = Mock.pub_key_1()

    tx = Transaction.create(pub_key_1, pub_key_1, 130)
    signed_tx = SignedTx.sign_tx(tx, private_key_miner)

    assert :ok = Pool.add_tx(signed_tx)
    assert :ok = Miner.mine_one_block()
    assert Tx.verify(signed_tx) == false
  end
end
