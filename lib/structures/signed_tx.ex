defmodule Blockchain.Structures.SignedTx do
  @moduledoc """
  Building signatures transactions
  """
  alias Blockchain.Structures.Transaction
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Utilities.Serialization

  defstruct [:data, :signature]

  @type t :: %SignedTx{data: Transaction.t(), signature: binary()}
  @coinbase_value 100

  @spec sign_tx(Transaction.t(), binary()) :: {:ok, SignedTx.t()}
  def sign_tx(data, private_key) do
    data_bin = Serialization.tx_to_binary(data)
    signature = :crypto.sign(:ecdsa, :sha256, data_bin, [private_key, :secp256k1])
    %SignedTx{data: data, signature: signature}
  end

  @spec coinbase_tx(binary()) :: SignedTx.t()
  def coinbase_tx(to_acc) do
    data = %Transaction{from_acc: nil, to_acc: to_acc, amount: @coinbase_value}
    %SignedTx{data: data, signature: nil}
  end
end
