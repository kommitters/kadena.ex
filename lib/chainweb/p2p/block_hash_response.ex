defmodule Kadena.Chainweb.P2P.BlockHashResponse do
  @moduledoc """
  `BlockHashResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type next :: String.t()
  @type limit :: non_neg_integer()
  @type items :: list()

  @type t :: %__MODULE__{
          next: next(),
          items: items(),
          limit: limit()
        }

  defstruct [:next, :items, :limit]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
