defmodule Kadena.Types.OptionalPactEventsList do
  @moduledoc """
  `OptionalPactEventsList` struct definition.
  """
  alias Kadena.Types.PactEventsList

  @behaviour Kadena.Types.Spec

  @type pact_events :: PactEventsList.t() | nil

  @type t :: %__MODULE__{pact_events: pact_events()}

  defstruct [:pact_events]

  @impl true
  def new(pact_events \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(%PactEventsList{} = pact_events), do: %__MODULE__{pact_events: pact_events}
  def new(_pact_events), do: {:error, [pact_events: :invalid]}
end
