defmodule Kadena.Chainweb.P2P.MempoolCheckResponse do
  @moduledoc """
  MempoolCheckResponse struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type results :: list(boolean())

  @type t :: %__MODULE__{results: results()}

  defstruct [:results]

  @impl true
  def new(attrs), do: %__MODULE__{results: attrs}
end
