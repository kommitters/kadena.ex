defmodule Kadena.Chainweb.P2P.PeerPutResponse do
  @moduledoc """
  `PeerPutResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.Peer

  @type peer :: Peer.t()

  @type t :: %__MODULE__{peer: peer}

  defstruct [:peer]

  @impl true
  def new(%Peer{} = peer), do: %__MODULE__{peer: peer}
end
