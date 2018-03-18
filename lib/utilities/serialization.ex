defmodule Blockchain.Utilities.Serialization do
  def tx_to_binary(data) do
    :erlang.term_to_binary(data)
  end

  def hash(term) do
    :crypto.hash(:sha256, tx_to_binary(term))
  end
end
