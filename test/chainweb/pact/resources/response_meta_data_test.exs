defmodule Kadena.Chainweb.Pact.Resources.ResponseMetaDataTest do
  @moduledoc """
  `ChainwebResponseMetaData` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Resources.{MetaDataResult, ResponseMetaData}
  alias Kadena.Types.ChainID

  setup do
    %{
      attrs: %{
        "block_hash" => "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
        "block_height" => 2708,
        "block_time" => 1_656_709_048_955_370,
        "prev_block_hash" => "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs",
        "public_meta" => %{
          "chain_id" => "0",
          "creation_time" => 0,
          "gas_limit" => 10,
          "gas_price" => 0,
          "sender" => "",
          "ttl" => 0
        }
      }
    }
  end

  test "new/1", %{attrs: attrs} do
    %ResponseMetaData{
      block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
      block_height: 2708,
      block_time: 1_656_709_048_955_370,
      prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs",
      public_meta: %MetaDataResult{
        chain_id: %ChainID{id: "0"},
        creation_time: 0,
        gas_limit: 10,
        gas_price: 0,
        sender: "",
        ttl: 0
      }
    } = ResponseMetaData.new(attrs)
  end

  test "new/1 with nil public_meta", %{attrs: attrs} do
    attrs = Map.put(attrs, "public_meta", nil)

    %ResponseMetaData{
      block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
      block_height: 2708,
      block_time: 1_656_709_048_955_370,
      prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs",
      public_meta: nil
    } = ResponseMetaData.new(attrs)
  end
end
