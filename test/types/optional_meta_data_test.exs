defmodule Kadena.Types.OptionalMetaDataTest do
  @moduledoc """
  `OptionalMetaData` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{MetaData, OptionalMetaData}

  describe "new/1" do
    test "with a valid list" do
      meta_data =
        MetaData.new(
          creation_time: 0,
          ttl: 0,
          gas_limit: 2500,
          gas_price: 1.0e-2,
          sender: "368820f80c324bbc7c2b0610688a7da43e39f91d118732671cd9c7500ff43cca",
          chain_id: "0"
        )

      %OptionalMetaData{meta_data: ^meta_data} = OptionalMetaData.new(meta_data)
    end

    test "without setting the args" do
      %OptionalMetaData{meta_data: nil} = OptionalMetaData.new()
    end

    test "with a nil value" do
      %OptionalMetaData{meta_data: nil} = OptionalMetaData.new(nil)
    end

    test "with an empty list value" do
      {:error, [meta_data: :invalid]} = OptionalMetaData.new([])
    end

    test "with an atom value" do
      {:error, [meta_data: :invalid]} = OptionalMetaData.new(:atom)
    end

    test "with a list of nil" do
      {:error, [meta_data: :invalid]} = OptionalMetaData.new([nil])
    end
  end
end
