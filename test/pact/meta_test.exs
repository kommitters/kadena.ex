defmodule Kadena.Pact.CannedMetaImpl do
  @moduledoc false

  @behaviour Kadena.Pact.Meta.Spec

  @impl true
  def create_meta(_sender, _chain_id, _gas_price, _gas_limit, _creation_time, _ttl) do
    send(self(), {:create_meta, "META"})
    :ok
  end
end

defmodule Kadena.Pact.MetaTest do
  @moduledoc """
  `Pact.Meta` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.{CannedMetaImpl, Meta}

  setup do
    Application.put_env(:kadena, :pact_meta_impl, CannedMetaImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :pact_meta_impl)
    end)
  end

  test "create_meta/6" do
    Meta.create_meta("SENDER", "CHAINID", "GASPRICE", "GASLIMIT", "CREATIONTIME", "TTL")
    assert_receive({:create_meta, "META"})
  end
end
