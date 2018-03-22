defmodule PoolTest do
  use ExUnit.Case

  alias Blockchain.Chain.Worker, as: Chain
  alias Blockchain.Miner.Worker, as: Miner
  alias Blockchain.Pool.Worker, as: Pool
  alias Blockchain.Keys.Mock
  alias Blockchain.Structures.Transaction
  alias Blockchain.Structures.SignedTx

  test "add and remove transaction from pool" do
    Chain.clean()
    Pool.take_and_remove_all_tx()
    private_key_miner = Mock.private_key_miner()
    pub_key_miner = Mock.pub_key_miner()

    private_key_1 = Mock.private_key_1()
    pub_key_1 = Mock.pub_key_1()

    tx = Transaction.create(pub_key_miner, pub_key_1, 10)
    signed_tx = SignedTx.sign_tx(tx, private_key_miner)

    assert :ok = Pool.add_tx(signed_tx)
    Pool.take_and_remove_all_tx()
    assert [] = Pool.check_pool()
  end
end
