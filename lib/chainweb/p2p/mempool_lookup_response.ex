defmodule Kadena.Chainweb.P2P.MempoolLookupResponse do
  @moduledoc """
  MempoolLookupResponse struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type results :: list(map())

  @type t :: %__MODULE__{results: results()}

  defstruct [:results]

  @impl true
  def new(attrs), do: %__MODULE__{results: attrs}
end
