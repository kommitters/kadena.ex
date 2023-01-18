defmodule Kadena.Chainweb.P2P.BlockHeaderByHashResponse do
  @moduledoc """
  `BlockHeaderByHashResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type item :: String.t() | map() | binary()

  @type t :: %__MODULE__{item: item()}

  defstruct [:item]

  @impl true
  def new(attr), do: %__MODULE__{item: attr}
end
