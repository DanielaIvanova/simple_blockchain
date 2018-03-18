defmodule Blockchain.Structures.Block do
  alias Blockchain.Structures.Block

  defstruct [:header, :txs]

  @type t :: %Block{header: Header.t(), txs: list(SignedTx.t())}

  @spec create(Header.t(), list(SignedTx.t())) :: Block.t()
  def create(header, txs) do
    %Block{header: header, txs: txs}
  end
end
