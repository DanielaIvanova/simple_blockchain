defmodule Blockchain.Structures.Block do
  alias Blockchain.Structures.Block

  defstruct [:header, :txs]

  @type t :: %Block{header: Header.t(), txs: list(SignedTx.t())}
end
