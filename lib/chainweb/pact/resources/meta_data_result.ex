defmodule Kadena.Chainweb.Pact.Resources.MetaDataResult do
  @moduledoc """
  `MetaDataResult` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Types.ChainID

  @behaviour Kadena.Chainweb.Resource

  @type creation_time :: number()
  @type ttl :: number()
  @type gas_limit :: number()
  @type gas_price :: number()
  @type sender :: String.t()
  @type chain_id :: ChainID.t()

  @type t :: %__MODULE__{
          creation_time: creation_time(),
          ttl: ttl(),
          gas_limit: gas_limit(),
          gas_price: gas_price(),
          sender: sender(),
          chain_id: chain_id()
        }

  defstruct [:creation_time, :ttl, :gas_limit, :gas_price, :sender, :chain_id]

  @mapping [chain_id: {:struct, ChainID}]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
