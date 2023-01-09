defmodule Kadena.Chainweb.P2P.CutResponseTest do
  @moduledoc """
  `CutResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.CutResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    hashes = %{
      "12": %{height: 3_350_810, hash: "AhycH3_Cm5vNhJDpIbWZCiQnf8gpBuFJMXia9IWiyhY"},
      "13": %{height: 3_350_810, hash: "T53jWSF7ptv4nhLLA6bMkRYarUN7mXFvJYDoj10WUwo"},
      "14": %{height: 3_350_810, hash: "R-V3KEhCjRlPSADuyTH7BO_yl4Czoaexi9z3wn9PvKQ"},
      "15": %{height: 3_350_810, hash: "JOyEl16czTUdjKaQ87UPSHEhYVjJbjxE6iuVmQqmWY4"},
      "8": %{height: 3_350_811, hash: "IuLhkJPxnXMTxS-yqdiiZycrO8TuWRLADSKU6gF0Xq0"},
      "9": %{height: 3_350_810, hash: "rBfNt0ko6NKapKcUF0GVPpvHljWC7REwWSQK6sDsM3o"},
      "10": %{height: 3_350_811, hash: "BAREvbDGlwIAd25-07Wsy9Bie4X4iRQoY7gZ20hKymo"},
      "11": %{height: 3_350_811, hash: "R4tkV9ll3cWQMk8EhncGtnBxNNA7bmqEySBpRlrFUUA"},
      "4": %{height: 3_350_811, hash: "oL5e3o3N-TFasjG74M5Mdt0DDh0Q_bIvnK1vlSuymTY"},
      "5": %{height: 3_350_810, hash: "YdCa2qi0mzXkXhm2nY1Wvva8R6wp0Hf5_v40bcubIxs"},
      "6": %{height: 3_350_811, hash: "Vpq2SBUmd8pwuGp62OkgmD6KH6lPnOZNtUo050LKZ1w"},
      "7": %{height: 3_350_811, hash: "MG9tHsLGYfl3RwvdAIeS4rMqyxaagCBSOuNx7hrhKSA"},
      "0": %{height: 3_350_810, hash: "MTqXrZQ7qZ7R-mfVrFjic44gKnGSXmBvfbw_wsfa9RI"},
      "16": %{height: 3_350_810, hash: "2gPywfZJxcCeHOE8x7zbPzilX0vxCtrjNNKW-qX0VaA"},
      "1": %{height: 3_350_810, hash: "R4OJy6BhVh3QvTL9ZOVN2hiYL92RlkK6qIbd3Lh9dVk"},
      "17": %{height: 3_350_810, hash: "x-HA372GM7YLteTIsyoONqsJs9mQHg8pf1sP8SplOa8"},
      "2": %{height: 3_350_810, hash: "62GIrxarXRjJatrvo5HxsCxydTaCzl85bd8pB0CFLQ8"},
      "18": %{height: 3_350_810, hash: "LEFgHmu82fvMq6y_gGXmZJYp5b0-v00mH945t7MY2QM"},
      "3": %{height: 3_350_811, hash: "wVbYjTs0GK0JbpIyMNDwQoHjVLooJnqSBCoe2sdbsNQ"},
      "19": %{height: 3_350_811, hash: "t29Iw-IePODh8l2pd4L2BTylEbGqkjMY7P8JP5kHMHQ"}
    }

    weight = "ZB92Nn9_T2nN5wMAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    height = 67_016_208
    instance = "mainnet01"
    id = "BsoV-rBBDF6caxH25NTBpyUoPtsYeLxVW4aG4_ZMjuM"

    %{
      attrs: Chainweb.fixture("cut"),
      hashes: hashes,
      weight: weight,
      height: height,
      instance: instance,
      id: id
    }
  end

  test "new/1", %{
    attrs: attrs,
    hashes: hashes,
    height: height,
    weight: weight
  } do
    %CutResponse{
      hashes: ^hashes,
      height: ^height,
      weight: ^weight,
      origin: nil
    } = CutResponse.new(attrs)
  end
end
