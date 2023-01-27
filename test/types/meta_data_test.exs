defmodule Kadena.Types.MetaDataTest do
  @moduledoc """
  `MetaData` struct definition tests.
  """

  alias Kadena.Types.{ChainID, MetaData}

  use ExUnit.Case

  describe "new/1" do
    test "with a valid list params" do
      %MetaData{
        creation_time: 0,
        ttl: 0,
        gas_limit: 2500,
        gas_price: 1.0e-2,
        sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
        chain_id: %ChainID{id: "0"}
      } =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )
    end

    test "with a valid map params" do
      %MetaData{
        creation_time: 0,
        ttl: 0,
        gas_limit: 2500,
        gas_price: 1.0e-2,
        sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
        chain_id: %ChainID{id: "0"}
      } =
        MetaData.new(%{
          "creation_time" => 0,
          "ttl" => 0,
          "gas_limit" => 2500,
          "gas_price" => 1.0e-2,
          "sender" => "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          "chain_id" => "0"
        })
    end

    test "with an invalid cration_time" do
      {:error, [creation_time: :invalid]} =
        MetaData.new(
          creation_time: "0",
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )
    end

    test "with an invalid ttl" do
      {:error, [ttl: :invalid]} =
        MetaData.new(
          creation_time: 0,
          ttl: "0",
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )
    end

    test "with an invalid gas_limit" do
      {:error, [gas_limit: :invalid]} =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: "2500",
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )
    end

    test "with an invalid gas_price" do
      {:error, [gas_price: :invalid]} =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: "1.0e-2",
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )
    end

    test "with an invalid sender" do
      {:error, [sender: :invalid]} =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: 123,
          chain_id: "0"
        )
    end

    test "with an invalid chain_id" do
      {:error, [chain_id: :invalid]} =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: 0
        )
    end

    test "with an invalid KeywordList" do
      {:error, [args: :not_a_list]} = MetaData.new("invalid_args")
    end
  end
end
