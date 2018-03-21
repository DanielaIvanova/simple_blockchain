defmodule Blockchain.Keys.Mock do
  @moduledoc """
  Hardcoded keys to work with Simple blockchain
  """
  alias Blockchain.Keys.Key

  @miner_private_key <<106, 137, 34, 241, 153, 153, 143, 101, 35, 80, 168, 30, 13, 201, 102, 94>>
  @private_key_1 <<116, 50, 190, 122, 49, 105, 145, 104, 198, 21, 69, 142, 28, 172, 190, 76>>
  @private_key_2 <<181, 72, 31, 65, 226, 248, 27, 164, 111, 191, 127, 220, 37, 33, 247, 173>>
  @private_key_3 <<102, 14, 21, 187, 68, 14, 52, 30, 242, 91, 159, 206, 34, 61, 74, 2>>

  def private_key_miner, do: @miner_private_key
  def pub_key_miner(), do: Key.create_public_key(@miner_private_key)

  def private_key_1(), do: @private_key_1
  def pub_key_1(), do: Key.create_public_key(@private_key_1)

  def private_key_2(), do: @private_key_2
  def pub_key_2(), do: Key.create_public_key(@private_key_2)

  def private_key_3(), do: @private_key_3
  def pub_key_3(), do: Key.create_public_key(@private_key_3)
end
