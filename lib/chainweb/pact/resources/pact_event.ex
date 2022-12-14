defmodule Kadena.Chainweb.Pact.Resources.PactEvent do
  @moduledoc """
  `PactEventModule` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Chainweb.Pact.Resources.PactEventModule
  alias Kadena.Types.PactValuesList

  @behaviour Kadena.Chainweb.Resource

  @type name :: String.t()
  @type pact_event_module :: PactEventModule.t()
  @type params :: PactValuesList.t()
  @type module_hash :: String.t()

  @type t :: %__MODULE__{
          name: name(),
          module: pact_event_module(),
          params: params(),
          module_hash: module_hash()
        }

  defstruct [:name, :module, :params, :module_hash]

  @mapping [
    module: {:struct, PactEventModule},
    params: {:struct, PactValuesList}
  ]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
