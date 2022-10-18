defmodule Kadena.Pact.Meta.Spec do
  @moduledoc """
  Specification for `Pact.Meta`.
  """

  alias Kadena.Types.{ChainID, MetaData}

  @type meta :: MetaData.t()
  @type creation_time :: number()
  @type ttl :: number()
  @type gas_limit :: number()
  @type gas_price :: number()
  @type sender :: String.t()
  @type chain_id :: ChainID.t()

  @callback create_meta(
              sender(),
              chain_id(),
              gas_price(),
              gas_limit(),
              creation_time(),
              ttl()
            ) :: {:ok, meta()}
end
