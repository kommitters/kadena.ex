defmodule Kadena.Chainweb.P2P.CutResponseTest do
  @moduledoc """
  `CutResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Cut
  alias Kadena.Chainweb.P2P.CutResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    cut_response = %CutResponse{
      cut: %Cut{
        hashes: %{
          "0": %{hash: "MTqXrZQ7qZ7R-mfVrFjic44gKnGSXmBvfbw_wsfa9RI", height: 3_350_810},
          "1": %{hash: "R4OJy6BhVh3QvTL9ZOVN2hiYL92RlkK6qIbd3Lh9dVk", height: 3_350_810},
          "10": %{hash: "BAREvbDGlwIAd25-07Wsy9Bie4X4iRQoY7gZ20hKymo", height: 3_350_811},
          "11": %{hash: "R4tkV9ll3cWQMk8EhncGtnBxNNA7bmqEySBpRlrFUUA", height: 3_350_811},
          "12": %{hash: "AhycH3_Cm5vNhJDpIbWZCiQnf8gpBuFJMXia9IWiyhY", height: 3_350_810},
          "13": %{hash: "T53jWSF7ptv4nhLLA6bMkRYarUN7mXFvJYDoj10WUwo", height: 3_350_810},
          "14": %{hash: "R-V3KEhCjRlPSADuyTH7BO_yl4Czoaexi9z3wn9PvKQ", height: 3_350_810},
          "15": %{hash: "JOyEl16czTUdjKaQ87UPSHEhYVjJbjxE6iuVmQqmWY4", height: 3_350_810},
          "16": %{hash: "2gPywfZJxcCeHOE8x7zbPzilX0vxCtrjNNKW-qX0VaA", height: 3_350_810},
          "17": %{hash: "x-HA372GM7YLteTIsyoONqsJs9mQHg8pf1sP8SplOa8", height: 3_350_810},
          "18": %{hash: "LEFgHmu82fvMq6y_gGXmZJYp5b0-v00mH945t7MY2QM", height: 3_350_810},
          "19": %{hash: "t29Iw-IePODh8l2pd4L2BTylEbGqkjMY7P8JP5kHMHQ", height: 3_350_811},
          "2": %{hash: "62GIrxarXRjJatrvo5HxsCxydTaCzl85bd8pB0CFLQ8", height: 3_350_810},
          "3": %{hash: "wVbYjTs0GK0JbpIyMNDwQoHjVLooJnqSBCoe2sdbsNQ", height: 3_350_811},
          "4": %{hash: "oL5e3o3N-TFasjG74M5Mdt0DDh0Q_bIvnK1vlSuymTY", height: 3_350_811},
          "5": %{hash: "YdCa2qi0mzXkXhm2nY1Wvva8R6wp0Hf5_v40bcubIxs", height: 3_350_810},
          "6": %{hash: "Vpq2SBUmd8pwuGp62OkgmD6KH6lPnOZNtUo050LKZ1w", height: 3_350_811},
          "7": %{hash: "MG9tHsLGYfl3RwvdAIeS4rMqyxaagCBSOuNx7hrhKSA", height: 3_350_811},
          "8": %{hash: "IuLhkJPxnXMTxS-yqdiiZycrO8TuWRLADSKU6gF0Xq0", height: 3_350_811},
          "9": %{hash: "rBfNt0ko6NKapKcUF0GVPpvHljWC7REwWSQK6sDsM3o", height: 3_350_810}
        },
        height: 67_016_208,
        id: "BsoV-rBBDF6caxH25NTBpyUoPtsYeLxVW4aG4_ZMjuM",
        instance: "mainnet01",
        origin: nil,
        weight: "ZB92Nn9_T2nN5wMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      }
    }

    %{
      attrs: Chainweb.fixture("cut"),
      cut_response: cut_response
    }
  end

  test "new/1", %{
    attrs: attrs,
    cut_response: cut_response
  } do
    ^cut_response = CutResponse.new(attrs)
  end
end
