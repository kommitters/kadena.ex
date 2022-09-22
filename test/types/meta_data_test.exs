defmodule Kadena.Types.MetaDataTest do
  @moduledoc """
  `MetaData` struct definition tests.
  """

  alias Kadena.Types.MetaData

  use ExUnit.Case

  describe "new/1" do
    test "with a valid param list" do
      %MetaData{
        creation_time: 0,
        ttl: 0,
        gas_limit: 2500,
        gas_price: 1.0e-2,
        sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
        chain_id: "0"
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

    test "with an invalid empty list" do
      {:error, :invalid_creation_time} =  MetaData.new([])
    end
    test "with an invalid cration_time" do
      {:error, :invalid_creation_time} =
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
      {:error, :invalid_ttl} =
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
      {:error, :invalid_gas_limit} =
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
      {:error, :invalid_gas_price} =
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
      {:error, :invalid_sender} =
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
      {:error, :invalid_chain_id} =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: 0
        )
    end
  end
end
end
