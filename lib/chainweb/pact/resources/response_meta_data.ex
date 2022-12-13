defmodule Kadena.Chainweb.Pact.Resources.ResponseMetaData do
  @moduledoc """
  `ResponseMetaData` struct definition.
  """

  alias Kadena.Chainweb.Mapping
  alias Kadena.Chainweb.Pact.Resources.MetaDataResult

  @behaviour Kadena.Chainweb.Resource

  @type hash :: String.t()
  @type block_hash :: hash()
  @type block_number :: number()
  @type block_time :: block_number()
  @type block_height :: block_number()
  @type prev_block_hash :: hash()
  @type public_meta :: MetaDataResult.t() | nil

  @type t :: %__MODULE__{
          block_hash: block_hash(),
          block_time: block_time(),
          block_height: block_height(),
          prev_block_hash: prev_block_hash(),
          public_meta: public_meta()
        }

  defstruct [:block_hash, :block_time, :block_height, :prev_block_hash, :public_meta]

  @mapping [public_meta: {:struct, MetaDataResult}]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
