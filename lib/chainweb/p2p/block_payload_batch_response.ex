defmodule Kadena.Chainweb.P2P.BlockPayloadBatchResponse do
  @moduledoc """
  `BlockPayloadBatchResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type
  alias Kadena.Chainweb.P2P.BlockPayloadResponse

  @type t :: %__MODULE__{batch: list(BlockPayloadResponse.t())}

  defstruct [:batch]
  @impl true
  def new(attrs), do: %__MODULE__{batch: attrs}
end
