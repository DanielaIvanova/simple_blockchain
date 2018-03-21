defmodule Blockchain.Structures.Block do
  @moduledoc """
  Building Block structures
  """
  alias Blockchain.Structures.Block
  alias Blockchain.Structures.Header

  defstruct [:header, :txs]

  @type t :: %Block{header: Header.t(), txs: list(SignedTx.t())}

  @spec create(Header.t(), list(SignedTx.t())) :: Block.t()
  def create(header, txs) do
    %Block{header: header, txs: txs}
  end

  @spec genesis_block() :: Block.t()
  def genesis_block() do
    header = Header.genesis_header()
    %Block{header: header, txs: []}
  end
end
