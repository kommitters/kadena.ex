defmodule Kadena.Pact.Meta do
  @moduledoc """
  Implementation for `Pact.Meta` functions.
  """

  alias Kadena.Pact.Meta

  @behaviour Meta.Spec

  @impl true
  def create_meta(sender, chain_id, gas_price, gas_limit, creation_time, ttl),
    do: impl().create_meta(sender, chain_id, gas_price, gas_limit, creation_time, ttl)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :pact_meta_impl, Meta.Default)
end
