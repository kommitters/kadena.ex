defmodule Kadena.Chainweb.P2P.BlockHashResponseTest do
  @moduledoc """
  `BlockHashResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockHashResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    items = [
      "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE",
      "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo"
    ]

    next = "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
    limit = 2

    %{
      attrs: Chainweb.fixture("block_hash_retrieve"),
      items: items,
      next: next,
      limit: limit
    }
  end

  test "new/1", %{
    attrs: attrs,
    items: items,
    next: next,
    limit: limit
  } do
    %BlockHashResponse{
      items: ^items,
      limit: ^limit,
      next: ^next
    } = BlockHashResponse.new(attrs)
  end
end
