defmodule Blockchain.Chain.ChainState do
  @spec update_account_money(map(), binary(), integer()) :: map()
  def update_account_money(state, acc, amount) do
    if Map.has_key?(state, acc) == false do
      Map.put(state, acc, amount)
    else
      new_balance = Map.get(state, acc) + amount
      Map.update!(state, acc, &(&1 + new_balance))
    end
  end

  def get_chain_state(block_state, chain_state) do
    Map.merge(block_state, chain_state, fn _key, v1, v2 ->
      v1 + v2
    end)
  end

  @spec get_block_state(list()) :: map()
  def get_block_state(txs) do
    state = %{}

    new_state =
      for tx <- txs do
        update =
          if tx.data.from_acc != nil do
            update_account_money(state, tx.data.from_acc, -tx.data.amount)
          else
            state
          end

        update_account_money(update, tx.data.to_acc, tx.data.amount)
      end

    List.foldl(new_state, %{}, fn n, acc ->
      Map.merge(n, acc, fn _key, v1, v2 ->
        v1 + v2
      end)
    end)
  end
end
