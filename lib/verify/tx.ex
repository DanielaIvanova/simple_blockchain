defmodule Blockchain.Verify.Tx do
  alias Blockchain.Structures.SignedTx
  alias Blockchain.Chain.Worker, as: Chain

  def verify(%SignedTx{data: data, signature: signature}) do
    with true <- validate_signature(%SignedTx{data: data, signature: signature}),
         check_balance(%SignedTx{data: data, signature: signature}) do
      true
    else
      false -> false
    end
  end

  @spec validate_signature(Signed.t()) :: boolean()
  defp validate_signature(%SignedTx{data: data, signature: signature}) do
    pubic_key = data.from_acc
    data_bin = data |> :erlang.term_to_binary()
    :crypto.verify(:ecdsa, :sha256, data_bin, signature, [pubic_key, :secp256k1])
  end

  @spec check_balance(Signed.t()) :: boolean()
  defp check_balance(%SignedTx{data: data, signature: _signature}) do
    balance_from_acc = Chain.get_balance(data.from_acc)
    balance_from_acc >= data.from_acc
  end
end
