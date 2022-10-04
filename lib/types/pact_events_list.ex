defmodule Kadena.Types.PactEventsList do
  @moduledoc """
  `PactEventsList` struct definition.
  """
  alias Kadena.Types.PactEvent

  @behaviour Kadena.Types.Spec

  @type pact_event :: PactEvent.t()
  @type pact_events :: list(pact_event())

  @type t :: %__MODULE__{pact_events: pact_events()}

  defstruct pact_events: []

  @impl true
  def new(pact_events), do: build_list(%__MODULE__{}, pact_events)

  @spec build_list(list :: t(), pact_events :: pact_events()) :: t() | {:error, Keyword.t()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{pact_events: list}, [%PactEvent{} = pact_event | rest]),
    do: build_list(%__MODULE__{pact_events: [pact_event | list]}, rest)

  defp build_list(%__MODULE__{pact_events: list}, [value | rest]) do
    case PactEvent.new(value) do
      %PactEvent{} = pact_event -> build_list(%__MODULE__{pact_events: [pact_event | list]}, rest)
      {:error, reason} -> {:error, [pact_events: :invalid] ++ reason}
    end
  end

  defp build_list(_list, _rest), do: {:error, [pact_events: :invalid_type]}
end
