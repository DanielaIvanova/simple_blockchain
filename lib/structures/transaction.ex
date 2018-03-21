defmodule Blockchain.Structures.Transaction do
  @moduledoc """
  Building transaction structures
  """
  alias Blockchain.Structures.Transaction

  defstruct [:from_acc, :to_acc, :amount]

  @type t :: %Transaction{from_acc: binary(), to_acc: binary(), amount: non_neg_integer()}

  @spec create(binary(), binary(), non_neg_integer()) :: Transaction.t()
  def create(from_acc, to_acc, amount) do
    %Transaction{from_acc: from_acc, to_acc: to_acc, amount: amount}
  end
end
