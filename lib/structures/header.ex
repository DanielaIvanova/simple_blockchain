defmodule Blockchain.Structures.Header do
  @moduledoc """
  Building header structures
  """
  alias Blockchain.Structures.Header

  defstruct [:previous_hash, :difficulty_target, :chain_state_root_hash, :txs_root_hash, :nonce]

  @type t :: %Header{
          previous_hash: binary(),
          difficulty_target: integer(),
          chain_state_root_hash: binary(),
          txs_root_hash: binary(),
          nonce: non_neg_integer()
        }

  @spec create(binary(), integer(), binary(), binary(), non_neg_integer()) :: Header.t()
  def create(previous_hash, difficulty_target, chain_state_root_hash, txs_root_hash, nonce) do
    %Header{
      previous_hash: previous_hash,
      difficulty_target: difficulty_target,
      chain_state_root_hash: chain_state_root_hash,
      txs_root_hash: txs_root_hash,
      nonce: nonce
    }
  end

  @spec genesis_header() :: Header.t()
  def genesis_header() do
    %Header{
      previous_hash: <<0::256>>,
      difficulty_target: 1,
      chain_state_root_hash: <<0::256>>,
      txs_root_hash: <<0::256>>,
      nonce: 0
    }
  end
end
