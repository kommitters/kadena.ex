defmodule Kadena.Chainweb.Pact.Resources.ProvenanceTest do
  @moduledoc """
  `Provenance` struct definition tests.
  """

  alias Kadena.Chainweb.Pact.Resources.Provenance
  alias Kadena.Types.ChainID

  use ExUnit.Case

  setup do
    %{
      attrs: %{
        "module_hash" => "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
        "target_chain_id" => "1"
      }
    }
  end

  test "new/1", %{attrs: attrs} do
    %Provenance{
      module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
      target_chain_id: %ChainID{id: "1"}
    } = Provenance.new(attrs)
  end
end
