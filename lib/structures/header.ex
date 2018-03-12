defmodule Blockchain.Structures.Header do
  alias Blockchain.Structures.Header

  defstruct [:previous_hash,
             :difficulty_target,
             :nonce]

  @type t :: %Header{previous_hash: binary(),
                     difficulty_target: integer(),
                     nonce: non_neg_integer()}


end
