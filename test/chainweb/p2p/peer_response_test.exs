defmodule Kadena.Chainweb.P2P.PeerResponseTest do
  @moduledoc """
  `PeerResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.PeerResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    items = [
      %{
        address: %{hostname: "65.109.23.84", port: 31_350},
        id: "MR1TFkDqCV557hwh1VOEJM1MfdFlOWt-ejpw58RwMzA"
      },
      %{
        address: %{hostname: "65.108.202.106", port: 31_350},
        id: "D0zC4BvxBseLKRljsyIHYkOtPLGkK96xfiE08yft34g"
      },
      %{
        address: %{hostname: "89.58.52.222", port: 31_350},
        id: "dGwxmR340CwVCRGh7vWRJn8-gxVevP9rwhxHWHeSK_w"
      },
      %{
        address: %{hostname: "65.108.9.161", port: 31_350},
        id: "_VA2_QqnUHXxekBiJT4ypxAi7znsR7oEsVRS_wk46nk"
      },
      %{
        address: %{hostname: "65.108.9.188", port: 31_350},
        id: "VQmD_ESHjDc_PBq15BShzJJZ74btZ_pIsK3jQSnXOkc"
      }
    ]

    next = "inclusive:5"
    limit = 5

    %{
      attrs: Chainweb.fixture("peer_retrieve_cut_info"),
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
    %PeerResponse{
      items: ^items,
      limit: ^limit,
      next: ^next
    } = PeerResponse.new(attrs)
  end
end
