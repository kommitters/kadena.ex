defmodule Kadena.Chainweb.Pact.Resources.YieldTest do
  @moduledoc """
  `Yield` struct definition tests.
  """

  alias Kadena.Chainweb.Pact.Resources.{Provenance, Yield}
  alias Kadena.Types.ChainID

  use ExUnit.Case

  setup do
    data = %{
      "amount" => 0.01,
      "receiver" => "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc",
      "receiver_guard" => %{
        "keys" => ["4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc"],
        "pred" => "keys-all"
      },
      "source_chain" => 0
    }

    provenance = %Provenance{
      module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
      target_chain_id: %ChainID{id: "1"}
    }

    attrs = %{
      "data" => data,
      "provenance" => %{
        "module_hash" => "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
        "target_chain_id" => "1"
      }
    }

    %{
      attrs: attrs,
      data: data,
      provenance: provenance
    }
  end

  test "new/1", %{attrs: attrs, data: data, provenance: provenance} do
    %Yield{data: ^data, provenance: ^provenance} = Yield.new(attrs)
  end

  test "new/1 with nil provenance", %{attrs: attrs, data: data} do
    attrs = Map.put(attrs, "provenance", nil)

    %Yield{data: ^data, provenance: nil} = Yield.new(attrs)
  end
end
