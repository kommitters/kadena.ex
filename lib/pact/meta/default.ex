defmodule Kadena.Pact.Meta.Default do
  @moduledoc """
  Default implementation for `Pact.Meta`.
  """

  alias Kadena.Types.MetaData

  @behaviour Kadena.Pact.Meta.Spec

  @impl true
  def create_meta(sender, chain_id, gas_price, gas_limit, creation_time, ttl) do
    meta =
      MetaData.new(
        sender: sender,
        chain_id: chain_id,
        gas_price: gas_price,
        gas_limit: gas_limit,
        creation_time: creation_time,
        ttl: ttl
      )

    case meta do
      %MetaData{} = meta -> {:ok, meta}
      error -> error
    end
  end
end
