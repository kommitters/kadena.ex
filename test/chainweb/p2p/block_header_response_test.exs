defmodule Kadena.Chainweb.P2P.BlockHeaderResponseTest do
  @moduledoc """
  `BlockHeaderResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockHashResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    encode_items = [
      "AAAAAAAAAAAIfWWp5I0FAAOanszcX9moxBJaDCEHqCUhaWSqqfpbCTZLelpSZ7AJAwACAAAAeDSfKbJMq5CZ7F5xKrsXYvaqJTSq_A9wbc7Q2SpgCYsDAAAA_rvcGOcdozdWaDSgaRFc_fK1n5v41BFIHF4Ji0RCGs4FAAAAVWvtK_H_uRSjz3gDcSL5bnKsBRsVQHXirfofzAXWtZD__________________________________________532Jt3v35NiAsLNFKMKLOjjLqnxYOTa5f86l1cfb_2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAAK9tc4PBNNdWsAGxIIczQTiOEbSlGfsBy5FMIqPuXSqR",
      "AAAAAAAAAAALvHz6WaIFAK9tc4PBNNdWsAGxIIczQTiOEbSlGfsBy5FMIqPuXSqRAwACAAAAFMsDXwQ2OS0NYmDwQsXR4rPyKA9oxJR2XK2OppSCD8EDAAAAtqjIgeqKe6q-BM4PeNmjHFgKHIWAziJxcgnrOuYInocFAAAAwXSuR_3WBkrdEV4proOm1YS4pBiX4uZI_KrNQfr24lv__________________________________________w2SsBq_3i0stplXyBZ3GUKRvdkkqMs1vSLIV4SGN95tAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAAN3h9dbyP8Gbj95RCnIpXwsfPf5Ge_JxbiSW7cuOIjQa"
    ]

    decode_items = [
      %{
        adjacents: %{
          "2": "eDSfKbJMq5CZ7F5xKrsXYvaqJTSq_A9wbc7Q2SpgCYs",
          "3": "_rvcGOcdozdWaDSgaRFc_fK1n5v41BFIHF4Ji0RCGs4",
          "5": "VWvtK_H_uRSjz3gDcSL5bnKsBRsVQHXirfofzAXWtZA"
        },
        chain_id: 0,
        chainweb_version: "testnet04",
        creation_time: 1_563_388_117_613_832,
        epoch_start: 1_563_388_117_613_832,
        feature_flags: 0,
        hash: "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE",
        height: 0,
        nonce: "0",
        parent: "A5qezNxf2ajEEloMIQeoJSFpZKqp-lsJNkt6WlJnsAk",
        payload_hash: "nfYm3e_fk2ICws0Uowos6OMuqfFg5Nrl_zqXVx9v_ZQ",
        target: "__________________________________________8",
        weight: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      },
      %{
        adjacents: %{
          "2": "FMsDXwQ2OS0NYmDwQsXR4rPyKA9oxJR2XK2OppSCD8E",
          "3": "tqjIgeqKe6q-BM4PeNmjHFgKHIWAziJxcgnrOuYInoc",
          "5": "wXSuR_3WBkrdEV4proOm1YS4pBiX4uZI_KrNQfr24ls"
        },
        chain_id: 0,
        chainweb_version: "testnet04",
        creation_time: 1_585_882_221_820_939,
        epoch_start: 1_563_388_117_613_832,
        feature_flags: 0,
        hash: "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo",
        height: 1,
        nonce: "0",
        parent: "r21zg8E011awAbEghzNBOI4RtKUZ-wHLkUwio-5dKpE",
        payload_hash: "DZKwGr_eLSy2mVfIFncZQpG92SSoyzW9IshXhIY33m0",
        target: "__________________________________________8",
        weight: "AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      }
    ]

    next = "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
    limit = 2

    %{
      encode_attrs: Chainweb.fixture("block_header_retrieve_encode"),
      decode_attrs: Chainweb.fixture("block_header_retrieve_decode"),
      encode_items: encode_items,
      decode_items: decode_items,
      next: next,
      limit: limit
    }
  end

  describe "new/1" do
    test "with encode items ", %{
      encode_attrs: encode_attrs,
      encode_items: encode_items,
      next: next,
      limit: limit
    } do
      %BlockHashResponse{
        items: ^encode_items,
        limit: ^limit,
        next: ^next
      } = BlockHashResponse.new(encode_attrs)
    end

    test "with decode items", %{
      decode_attrs: decode_attrs,
      decode_items: decode_items,
      next: next,
      limit: limit
    } do
      %BlockHashResponse{
        items: ^decode_items,
        limit: ^limit,
        next: ^next
      } = BlockHashResponse.new(decode_attrs)
    end
  end
end
