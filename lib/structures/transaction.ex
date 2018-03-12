defmodule Blockchain.Structures.Transaction do
  alias Blockchain.Structures.Transaction

  defstruct [:from_acc, :to_acc, :amount]

  @type t :: %Transaction{from_acc: binary(),
                          to_acc: binary(),
                          amount: non_neg_integer()}
end
