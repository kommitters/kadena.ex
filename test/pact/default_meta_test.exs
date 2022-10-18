defmodule Kadena.Pact.DefaultMetaTest do
  @moduledoc """
  `Pact.Meta.Default` functions tests.
  """

  use ExUnit.Case

  alias Kadena.{Pact.Meta, Types.ChainID, Types.MetaData}

  describe "create_meta/6" do
    test "with valid args" do
      {:ok,
       %MetaData{
         chain_id: %ChainID{id: ""},
         creation_time: 1_655_142_318,
         gas_limit: 600,
         gas_price: 1.0e-5,
         sender: "",
         ttl: 28_800
       }} = Meta.create_meta("", "", 0.00001, 600, 1_655_142_318, 28_800)
    end

    test "with invalid sender" do
      {:error, [sender: :invalid]} = Meta.create_meta(1, "", 0.00001, 600, 1_655_142_318, 28_800)
    end
  end
end
