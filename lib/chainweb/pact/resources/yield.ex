defmodule Kadena.Chainweb.Pact.Resources.Yield do
  @moduledoc """
  `Yield` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Chainweb.Pact.Resources.Provenance

  @behaviour Kadena.Chainweb.Resource

  @type data :: map()
  @type provenance :: Provenance.t() | nil

  @type t :: %__MODULE__{
          data: data(),
          provenance: provenance()
        }

  defstruct [:data, :provenance]

  @mapping [provenance: {:struct, Provenance}]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
