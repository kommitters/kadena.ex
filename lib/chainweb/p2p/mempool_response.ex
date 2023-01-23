defmodule Kadena.Chainweb.P2P.MempoolResponse do
  @moduledoc """
  `MempoolResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type hashes :: list(String.t())
  @type highwater_mark :: list(integer())

  @type t :: %__MODULE__{
          hashes: hashes(),
          highwater_mark: highwater_mark()
        }

  defstruct [:hashes, :highwater_mark]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
