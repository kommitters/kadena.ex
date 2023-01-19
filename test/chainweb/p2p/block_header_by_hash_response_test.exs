defmodule Kadena.Chainweb.P2P.BlockHeaderByHashResponseTest do
  @moduledoc """
  `BlockHeaderByHashResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.BlockHeaderByHashResponse
  alias Kadena.Test.Fixtures.Chainweb

  setup do
    encode_item =
      "AAAAAAAAAAC-CZT7WaIFAN3h9dbyP8Gbj95RCnIpXwsfPf5Ge_JxbiSW7cuOIjQaAwACAAAAOKrakx1LFapdQurxTNFb6qA4P-JxDu21DJuWNKzx9YQDAAAAo6s-Ne3AmA1EQpNYQFGm9FnuIVGJiyyeCkMKt9PxlwoFAAAAihn-S5iteAEmY3B8xTFU6oN_yX6V5-YxrR6UMNJDbhb__________________________________________0fwmB_uakipwfXi5V6Zcuw0RXT1KABdNlTSlNrl0fP9AAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAADOHaA_ozB8sYuE73wQ1Mt8fVTJHC8YJ6Y7b223dMlEA"

    decode_item = %{
      adjacents: %{
        "2": "OKrakx1LFapdQurxTNFb6qA4P-JxDu21DJuWNKzx9YQ",
        "3": "o6s-Ne3AmA1EQpNYQFGm9FnuIVGJiyyeCkMKt9Pxlwo",
        "5": "ihn-S5iteAEmY3B8xTFU6oN_yX6V5-YxrR6UMNJDbhY"
      },
      chain_id: 0,
      chainweb_version: "testnet04",
      creation_time: 1_585_882_240_125_374,
      epoch_start: 1_563_388_117_613_832,
      feature_flags: 0,
      hash: "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
      height: 2,
      nonce: "0",
      parent: "3eH11vI_wZuP3lEKcilfCx89_kZ78nFuJJbty44iNBo",
      payload_hash: "R_CYH-5qSKnB9eLlXply7DRFdPUoAF02VNKU2uXR8_0",
      target: "__________________________________________8",
      weight: "AgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    }

    binary_item =
      <<0, 0, 0, 0, 0, 0, 0, 0, 190, 9, 148, 251, 89, 162, 5, 0, 221, 225, 245, 214, 242, 63, 193,
        155, 143, 222, 81, 10, 114, 41, 95, 11, 31, 61, 254, 70, 123, 242, 113, 110, 36, 150, 237,
        203, 142, 34, 52, 26, 3, 0, 2, 0, 0, 0, 56, 170, 218, 147, 29, 75, 21, 170, 93, 66, 234,
        241, 76, 209, 91, 234, 160, 56, 63, 226, 113, 14, 237, 181, 12, 155, 150, 52, 172, 241,
        245, 132, 3, 0, 0, 0, 163, 171, 62, 53, 237, 192, 152, 13, 68, 66, 147, 88, 64, 81, 166,
        244, 89, 238, 33, 81, 137, 139, 44, 158, 10, 67, 10, 183, 211, 241, 151, 10, 5, 0, 0, 0,
        138, 25, 254, 75, 152, 173, 120, 1, 38, 99, 112, 124, 197, 49, 84, 234, 131, 127, 201,
        126, 149, 231, 230, 49, 173, 30, 148, 48, 210, 67, 110, 22, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 71, 240, 152, 31, 238, 106, 72, 169, 193, 245,
        226, 229, 94, 153, 114, 236, 52, 69, 116, 245, 40, 0, 93, 54, 84, 210, 148, 218, 229, 209,
        243, 253, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8, 125, 101, 169, 228, 141,
        5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 135, 104, 15, 232, 204, 31, 44, 98, 225, 59, 223, 4, 53,
        50, 223, 31, 85, 50, 71, 11, 198, 9, 233, 142, 219, 219, 109, 221, 50, 81, 0>>

    next = "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
    limit = 2

    %{
      encode_attrs: Chainweb.fixture("block_header_retrieve_by_hash_encode"),
      decode_attrs: Chainweb.fixture("block_header_retrieve_by_hash_decode"),
      encode_item: encode_item,
      decode_item: decode_item,
      binary_item: binary_item,
      next: next,
      limit: limit
    }
  end

  describe "new/1" do
    test "with encode item", %{
      encode_attrs: encode_attrs,
      encode_item: encode_item
    } do
      %BlockHeaderByHashResponse{
        item: ^encode_item
      } = BlockHeaderByHashResponse.new(encode_attrs)
    end

    test "with decode item", %{
      decode_attrs: decode_attrs,
      decode_item: decode_item
    } do
      %BlockHeaderByHashResponse{
        item: ^decode_item
      } = BlockHeaderByHashResponse.new(decode_attrs)
    end

    test "with binary item", %{
      binary_item: binary_item
    } do
      %BlockHeaderByHashResponse{
        item: ^binary_item
      } = BlockHeaderByHashResponse.new(binary_item)
    end
  end
end
