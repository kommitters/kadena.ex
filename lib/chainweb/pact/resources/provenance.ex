defmodule Kadena.Chainweb.Pact.Resources.Provenance do
  @moduledoc """
  `Provenance` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Types.ChainID

  @behaviour Kadena.Chainweb.Resource

  @type target_chain_id :: ChainID.t()
  @type module_hash :: String.t()

  @type t :: %__MODULE__{
          target_chain_id: target_chain_id(),
          module_hash: module_hash()
        }

  defstruct [:target_chain_id, :module_hash]

  @mapping [target_chain_id: {:struct, ChainID}]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
