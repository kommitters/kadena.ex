defmodule Kadena.Chainweb.P2P.BlockPayloadBatchWithOutputsResponse do
  @moduledoc """
  `BlockPayloadBatchWithOutputsResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type
  alias Kadena.Chainweb.P2P.BlockPayloadWithOutputsResponse

  @type t :: %__MODULE__{batch: list(BlockPayloadWithOutputsResponse.t())}

  defstruct [:batch]
  @impl true
  def new(attrs), do: %__MODULE__{batch: attrs}
end
