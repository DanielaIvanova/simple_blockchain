defmodule Blockchain.Chain.ChainState do
  def get_chain_state(block_state, chain_state) do
    Map.merge(block_state, chain_state, fn _key, v1, v2 ->
      v1 + v2
    end)
  end

  @spec get_block_state(list()) :: list()
  def get_block_state(txs) do
    state = %{}

    new_state =
      for tx <- txs do
        update =
          if tx.data.from_acc != nil do
            update_block_state(state, tx.data.from_acc, -tx.data.amount)
          else
            state
          end

        update_block_state(update, tx.data.to_acc, tx.data.amount)
      end

    List.foldl(new_state, %{}, fn n, acc ->
      Map.merge(n, acc, fn _key, v1, v2 ->
        v1 + v2
      end)
    end)
  end

  def update_block_state(state, acc, amount) do
    if Map.has_key?(state, acc) == false do
      Map.put(state, acc, amount)
    else
      new_balance = Map.get(state, acc) + amount
      Map.update!(state, acc, &(&1 + new_balance))
    end
  end
end
