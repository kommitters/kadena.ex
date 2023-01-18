defmodule Kadena.Chainweb.P2P.CutResponse do
  @moduledoc """
  `CutResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.Cut

  @type cut :: Cut.t()

  @type t :: %__MODULE__{cut: cut()}

  defstruct [:cut]

  @impl true
  def new(%Cut{} = cut), do: %__MODULE__{cut: cut}
  def new(attrs), do: %__MODULE__{cut: Cut.new(attrs)}
end
