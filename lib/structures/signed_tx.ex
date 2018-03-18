defmodule Blockchain.Structures.SignedTx do
  alias Blockchain.Structures.Transaction
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Utilities.Serialization

  defstruct [:data, :signature]

  @type t :: %SignedTx{data: Transaction.t(), signature: binary()}

  @spec sign_tx(Transaction.t(), binary()) :: {:ok, SignedTx.t()}
  def sign_tx(data, private_key) do
    data_bin = Serialization.tx_to_binary(data)
    signature = :crypto.sign(:ecdsa, :sha256, data_bin, [private_key, :secp256k1])
    {:ok, %SignedTx{data: data, signature: signature}}
  end
end
