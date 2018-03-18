defmodule Blockchain.Structures.User do
  alias Blockchain.Structures.User

  defstruct [:balance]

  @type t :: %User{balance: non_neg_integer()}
end
