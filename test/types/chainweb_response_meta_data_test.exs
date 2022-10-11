defmodule Kadena.Types.ChainwebResponseMetaDataTest do
  @moduledoc """
  `ChainwebResponseMetaData` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{ChainwebResponseMetaData, MetaData, OptionalMetaData}

  describe "new/1" do
    setup do
      meta_data_list = [
        creation_time: 0,
        ttl: 0,
        gas_limit: 2500,
        gas_price: 1.0e-2,
        sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
        chain_id: "0"
      ]

      %{
        block_hash: "kZCKTbL3ubONngiGQsJh4fGtP1xrhAoUvcTsqi3uCGg",
        block_time: 1_656_709_048_955_370,
        block_height: 2708,
        prev_block_hash: "LD_o60RB4xnMgLyzkedNV6v-hbCCnx6WXRQy9WDKTgs",
        meta_data_list: meta_data_list,
        meta_data_struct: MetaData.new(meta_data_list)
      }
    end

    test "with a valid list", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash
    } do
      %ChainwebResponseMetaData{
        block_hash: ^block_hash,
        block_time: ^block_time,
        block_height: ^block_height,
        prev_block_hash: ^prev_block_hash,
        public_meta: %OptionalMetaData{meta_data: nil}
      } =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash
        )
    end

    test "with a valid meta_data list", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash,
      meta_data_list: meta_data_list,
      meta_data_struct: meta_data
    } do
      %ChainwebResponseMetaData{
        block_hash: ^block_hash,
        block_time: ^block_time,
        block_height: ^block_height,
        prev_block_hash: ^prev_block_hash,
        public_meta: %OptionalMetaData{meta_data: ^meta_data}
      } =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash,
          public_meta: meta_data_list
        )
    end

    test "with a valid meta_data struct", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash,
      meta_data_struct: meta_data
    } do
      %ChainwebResponseMetaData{
        block_hash: ^block_hash,
        block_time: ^block_time,
        block_height: ^block_height,
        prev_block_hash: ^prev_block_hash,
        public_meta: %OptionalMetaData{meta_data: ^meta_data}
      } =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash,
          public_meta: meta_data
        )
    end

    test "with a valid optional_meta_data struct", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash,
      meta_data_struct: meta_data
    } do
      optional_meta_data = OptionalMetaData.new(meta_data)

      %ChainwebResponseMetaData{
        block_hash: ^block_hash,
        block_time: ^block_time,
        block_height: ^block_height,
        prev_block_hash: ^prev_block_hash,
        public_meta: ^optional_meta_data
      } =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash,
          public_meta: optional_meta_data
        )
    end

    test "with an invalid block_hash", %{
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash
    } do
      {:error, [block_hash: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: :hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash
        )
    end

    test "with an invalid block_time", %{
      block_hash: block_hash,
      block_height: block_height,
      prev_block_hash: prev_block_hash
    } do
      {:error, [block_time: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: "1656709048955370",
          block_height: block_height,
          prev_block_hash: prev_block_hash
        )
    end

    test "with an invalid block_height", %{
      block_hash: block_hash,
      block_time: block_time,
      prev_block_hash: prev_block_hash
    } do
      {:error, [block_height: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: "2708",
          prev_block_hash: prev_block_hash
        )
    end

    test "with an invalid prev_block_hash", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height
    } do
      {:error, [prev_block_hash: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: :hash
        )
    end

    test "with an invalid public_meta arg", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash
    } do
      {:error, [public_meta: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash,
          public_meta: "invalid"
        )
    end

    test "with an invalid public_meta", %{
      block_hash: block_hash,
      block_time: block_time,
      block_height: block_height,
      prev_block_hash: prev_block_hash
    } do
      {:error, [public_meta: :invalid, creation_time: :invalid]} =
        ChainwebResponseMetaData.new(
          block_hash: block_hash,
          block_time: block_time,
          block_height: block_height,
          prev_block_hash: prev_block_hash,
          public_meta: [name: "public_meta", invalid: "invalid"]
        )
    end
  end
end
