# Simple Blockchain

The application is simple implementation of blockchain. There're functionality for creating transactions, putting them to the pool of transaction, verifying, mining the new block and adding to the chain of blocks.

## Setup

You need to have Elixir 1.6 and Erlang/OTP 20. Detailed installation instructions can be found at [http://elixir-lang.org/install.html](http://elixir-lang.org/install.html).

## How to use Simple Blockchain

#### **Fetching dependencies**
`mix deps.get`

#### **Starting the application**
Start the application in interactive Elixir mode

`iex -S mix`

#### **Start the miner**
`Blockchain.Miner.Worker.start()`

This will continuously mine new blocks until you stop the miner.

#### **Mine only one block **
`Blockchain.Miner.Worker.mine_one_block`

This will mine only one block.

#### **Stop the miner**
`Blockchain.Miner.Worker.stop()`

#### **Get the latest chainstate**
`Blockchain.Chain.Worker.get_state`

There is information about last block in the chain and accounts with their tokens

#### **See transactions in the pool**
`Blockchain.Pool.Worker.check_pool()`

### Example

You have to start the miner first for 10-15 seconds:
`Blockchain.Miner.Worker.start()`

Stop the miner:
`Blockchain.Miner.Worker.stop()`

You can chack your balanace in the chanstate:
`Blockchain.Chain.Worker.get_state`

Create a transaction:
- Create private and public key
`private_key_miner = Blockchain.Keys.Mock.private_key_miner()`
`pub_key_miner = Blockchain.Keys.Mock.pub_key_miner()`

`private_key_1 = Blockchain.Keys.Mock.private_key_1()`
`pub_key_1 = Blockchain.Keys.Mock.pub_key_1()`

- Build the transaction
`alias Blockchain.Structures.Transaction`
`alias Blockchain.Structures.SignedTx`
`alias Blockchain.Pool.Worker, as: Pool`

`data = %Transaction{from_acc: pub_key_miner, to_acc: pub_key_1, amount: 100}`
`tx = SignedTx.sign_tx(data, private_key_miner)`

- Add the transaction to the pool
`Blockchain.Pool.Worker.add_tx(tx)`

- Check what is in the pool
`Blockchain.Pool.Worker.check_pool()`

- Mine one block
`Blockchain.Miner.Worker.mine_one_block`

- Check the state
`Blockchain.Chain.Worker.get_state`








