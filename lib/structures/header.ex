defmodule Blockchain.Structures.Header do
  alias Blockchain.Structures.Header

  defstruct [:previous_hash, :difficulty_target, :nonce]

  @type t :: %Header{
          previous_hash: binary(),
          difficulty_target: integer(),
          nonce: non_neg_integer()
        }

  @spec create(binary(), integer(), non_neg_integer()) :: Header.t()
  def create(previous_hash, difficulty_target, nonce) do
    %Header{previous_hash: previous_hash, difficulty_target: difficulty_target, nonce: nonce}
  end
end
