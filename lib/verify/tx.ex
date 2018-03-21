defmodule Blockchain.Verify.Tx do
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Chain.Worker, as: Chain

  @spec verify(SignedTx.t()) :: boolean()
  def verify(%SignedTx{data: data, signature: signature}) do
    validate_signature(%SignedTx{data: data, signature: signature}) &&
      check_balance(%SignedTx{data: data, signature: signature})
  end

  @spec validate_signature(SignedTx.t()) :: boolean()
  defp validate_signature(%SignedTx{data: data, signature: signature}) do
    pubic_key = data.from_acc
    data_bin = data |> :erlang.term_to_binary()
    :crypto.verify(:ecdsa, :sha256, data_bin, signature, [pubic_key, :secp256k1])
  end

  @spec check_balance(SignedTx.t()) :: boolean()
  defp check_balance(%SignedTx{data: data, signature: _signature}) do
    balance_from_acc = Chain.get_balance(data.from_acc)

    if balance_from_acc != nil do
      balance_from_acc >= data.amount
    else
      false
    end
  end
end
