defmodule Blockchain.Keys.Key do
  def create_private_key() do
    entropy_byte_size = 16
    :crypto.strong_rand_bytes(entropy_byte_size)
  end

  def create_public_key(private_key) do
    :crypto.generate_key(:ecdh, :secp256k1, private_key)
  end

  def get_public_key() do
    {pub_key, _priv_key} = create_private_key() |> create_public_key()
    pub_key
  end
end
