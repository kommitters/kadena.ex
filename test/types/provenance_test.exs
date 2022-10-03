defmodule Kadena.Types.ProvenanceTest do
  @moduledoc """
  `Provenance` struct definition tests.
  """

  alias Kadena.Types.{ChainID, Provenance}

  use ExUnit.Case

  describe "new/1" do
    test "with valid args" do
      %Provenance{
        target_chain_id: %ChainID{id: "1"},
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
      } =
        Provenance.new(
          target_chain_id: "1",
          module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
        )
    end

    test "with an invalid chain id" do
      {:error, [target_chain_id: :invalid]} =
        Provenance.new(
          target_chain_id: 1,
          module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
        )
    end

    test "with an invalid module hash" do
      {:error, [module_hash: :invalid]} =
        Provenance.new(
          target_chain_id: "1",
          module_hash: 123
        )
    end

    test "with an invalid empty list" do
      {:error, [target_chain_id: :invalid]} = Provenance.new([])
    end
  end
end
