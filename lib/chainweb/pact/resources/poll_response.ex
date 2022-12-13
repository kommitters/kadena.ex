defmodule Kadena.Chainweb.Pact.Resources.PollResponse do
  @moduledoc """
  `PollResponse` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Chainweb.Pact.Resources.CommandResult

  @behaviour Kadena.Chainweb.Resource

  @type results :: list(CommandResult.t())

  @type t :: %__MODULE__{results: results()}

  defstruct [:results]

  @mapping [results: {:list, :struct, CommandResult}]

  @impl true
  def new(attrs) do
    values = Map.values(attrs)
    attrs = %{"results" => values}

    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
