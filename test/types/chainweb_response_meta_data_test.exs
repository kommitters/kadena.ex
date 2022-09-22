defmodule Kadena.Types.ChainwebResponseMetaDataTest do
  @moduledoc """
  `ChainwebResponseMetaData` struct definition tests.
  """

  alias Kadena.Types.ChainwebResponseMetaData

  use ExUnit.Case

  describe "new/1" do
    test "with a valid list" do
      %ChainwebResponseMetaData{
        block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
        block_time: 1_656_709_048_955_370,
        block_height: 2708,
        prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
      } =
        ChainwebResponseMetaData.new(
          block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
          block_time: 1_656_709_048_955_370,
          block_height: 2708,
          prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
        )
    end
    test "with an invalid empty list" do
      {:error, :invalid_block_hash} =
        ChainwebResponseMetaData.new([])
    end
    test "with an invalid block_hash" do
      {:error, :invalid_block_hash} =
        ChainwebResponseMetaData.new(
          block_hash: 1_656_709_048_955_370,
          block_time: 1_656_709_048_955_370,
          block_height: 2708,
          prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
        )
    end

    test "with an invalid block_time" do
      {:error, :invalid_block_time} =
        ChainwebResponseMetaData.new(
          block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
          block_time: "1_656_709_048_955_370",
          block_height: 2708,
          prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
        )
    end

    test "with an invalid block_height" do
      {:error, :invalid_block_height} =
        ChainwebResponseMetaData.new(
          block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
          block_time: 1_656_709_048_955_370,
          block_height: "2708",
          prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs"
        )
    end

    test "with an invalid prev_block_hash" do
      {:error, :invalid_prev_block_hash} =
        ChainwebResponseMetaData.new(
          block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
          block_time: 1_656_709_048_955_370,
          block_height: 2708,
          prev_block_hash: 1_656_709_048_955_370
        )
    end

    test "with an invalid nil value" do
      {:error, :invalid_block_hash} = ChainwebResponseMetaData.new(nil)
    end
  end
end
