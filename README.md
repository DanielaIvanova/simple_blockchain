# Simple Blockchain

This application is a simple blockchain implementation. There is functionality for creating transactions, putting them in the transactions pool, verifying, mining the new block and adding to the blockchain.

## Setup

You need to have Elixir 1.6 and Erlang/OTP 20. Detailed installation instructions can be found at: [http://elixir-lang.org/install.html](http://elixir-lang.org/install.html).

## How to use Simple Blockchain

#### **Fetching dependencies**
```
mix deps.get
```

#### **Starting the application**
Start the application in interactive Elixir mode

```
iex -S mix
```

#### **Start the miner**
```
iex> Blockchain.Miner.Worker.start()
```

This will continuously mine new blocks until you stop the miner.

#### **Mine only one block**
```
iex> Blockchain.Miner.Worker.mine_one_block()
```

This will mine only one block.

#### **Stop the miner**
```
iex> Blockchain.Miner.Worker.stop()
```

#### **Get the latest chainstate**
```
iex> Blockchain.Chain.Worker.get_state()
```

There is information about last block in the chain and accounts with their tokens

#### **See transactions in the pool**
```
iex> Blockchain.Pool.Worker.check_pool()
```

### Example

To interact with blockchain first of all you should have some tokens. 
To generate them you have to start miner for at least 10 seconds.

```
iex> Blockchain.Miner.Worker.start()
```

Stop the miner:

```
iex> Blockchain.Miner.Worker.stop()
```

You can check your balance in the chanstate:

```
iex> Blockchain.Chain.Worker.get_state()
```

To create a transaction you should have private and public key.
- Create private and public key:


```
iex> private_key_miner = Blockchain.Keys.Mock.private_key_miner()
iex> pub_key_miner = Blockchain.Keys.Mock.pub_key_miner()
iex> private_key_1 = Blockchain.Keys.Mock.private_key_1()
iex> pub_key_1 = Blockchain.Keys.Mock.pub_key_1()
```


- Then, build the transaction:

```
iex> alias Blockchain.Structures.Transaction
iex> alias Blockchain.Structures.SignedTx
iex> alias Blockchain.Pool.Worker, as: Pool
iex> data = Transaction.create(pub_key_miner, pub_key_1, 100)
iex> tx = SignedTx.sign_tx(data, private_key_miner)
```

- Next, add the transaction to the pool: 


```
iex> Blockchain.Pool.Worker.add_tx(tx)
```

- To check what is in the pool:


```
iex> Blockchain.Pool.Worker.check_pool()
```

- To mine one block


```
iex> Blockchain.Miner.Worker.mine_one_block()
```

If you have enough money the transaction will appear in the new block.
Otherwise the transaction will stay in the pool.

- Check the state to see if yout transaction is in the new block. 

```
iex> Blockchain.Chain.Worker.get_state()
```








