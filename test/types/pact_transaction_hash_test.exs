defmodule KadenaTypes.PactTransactionHashTest do
  @moduledoc """
  `PactTransactionHash` struct definition tests.
  """

  alias Kadena.Types.PactTransactionHash

  use ExUnit.Case

  describe "new/1" do
    test "with a valid hash" do
      %PactTransactionHash{hash: "yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4"} =
        PactTransactionHash.new("yxM0umrtdcvSUZDc_GSjwadH6ELYFCjOqI59Jzqapi4")
    end

    test "with an invalid hash" do
      {:error, {:hash, :invalid}} = PactTransactionHash.new(:invalid_hash)
    end

    test "with a nil value" do
      {:error, {:hash, :invalid}} = PactTransactionHash.new(nil)
    end
  end
end
