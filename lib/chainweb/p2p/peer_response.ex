defmodule Kadena.Chainweb.P2P.PeerResponse do
  @moduledoc """
  `PeerResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type next :: String.t() | nil
  @type limit :: non_neg_integer()
  @type items :: list(map())

  @type t :: %__MODULE__{
          next: next(),
          items: items(),
          limit: limit()
        }

  defstruct [:items, :limit, :next]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
