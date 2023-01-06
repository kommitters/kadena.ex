defmodule Kadena.Chainweb.Pact.PollResponse do
  @moduledoc """
  `PollResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.Pact.CommandResult

  @type results :: list(CommandResult.t())

  @type t :: %__MODULE__{results: results()}

  defstruct [:results]

  @impl true
  def new(attrs) do
    results =
      attrs
      |> Map.values()
      |> Enum.map(&CommandResult.new/1)

    struct(%__MODULE__{}, results: results)
  end
end
