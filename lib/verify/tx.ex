defmodule Blockchain.Verify.Tx do
  alias Blockchain.Structures.SignedTx

  def verify(%SignedTx{data: data, signature: signature}) do
    with true <- validate_signature(%SignedTx{data: data, signature: signature}) do
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
end
