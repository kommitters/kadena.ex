defmodule Kadena.Chainweb.Client.CannedBlockHeaderRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.BlockHeaderByHashResponse
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header?limit=2",
        [{"Accept", "application/json"}],
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_header_retrieve_encode")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header?limit=2&next=inclusive%3AM4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA&minheight=0&maxheight=50000",
        [{"Accept", "application/json"}],
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_header_retrieve_encode2")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header?limit=2",
        [{"Accept", "application/json;blockheader-encoding=object"}],
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_header_retrieve_decode")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header?limit=2&next=invalid&minheight=0&maxheight=50000",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"invalid\\\".\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/header",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: :network_error,
           title: :nxdomain
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.chainweb.com/chainweb/0.0/mainnet01/chain/20/header",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
        [{"Accept", "application/json;blockheader-encoding=object"}],
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_header_retrieve_by_hash_decode")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
        [{"Accept", "application/octet-stream"}],
        _body,
        _options
      ) do
    response =
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

    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("block_header_retrieve_by_hash_encode")
    {:ok, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/invalid",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: "DecodeException \"not enough bytes\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/21/header/invalid",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title: "not found"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://api.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/header/M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 404,
           title:
             "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
         }}
      )

    {:error, response}
  end
end

defmodule Kadena.Chainweb.P2P.BlockHeaderTest do
  @moduledoc """
  `BlockHeader` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedBlockHeaderRequests
  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.{BlockHeader, BlockHeaderByHashResponse, BlockHeaderResponse}

  describe "retrieve/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockHeaderRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      success_response =
        {:ok,
         %BlockHeaderResponse{
           items: [
             "AAAAAAAAAAAIfWWp5I0FAAOanszcX9moxBJaDCEHqCUhaWSqqfpbCTZLelpSZ7AJAwACAAAAeDSfKbJMq5CZ7F5xKrsXYvaqJTSq_A9wbc7Q2SpgCYsDAAAA_rvcGOcdozdWaDSgaRFc_fK1n5v41BFIHF4Ji0RCGs4FAAAAVWvtK_H_uRSjz3gDcSL5bnKsBRsVQHXirfofzAXWtZD__________________________________________532Jt3v35NiAsLNFKMKLOjjLqnxYOTa5f86l1cfb_2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAAK9tc4PBNNdWsAGxIIczQTiOEbSlGfsBy5FMIqPuXSqR",
             "AAAAAAAAAAALvHz6WaIFAK9tc4PBNNdWsAGxIIczQTiOEbSlGfsBy5FMIqPuXSqRAwACAAAAFMsDXwQ2OS0NYmDwQsXR4rPyKA9oxJR2XK2OppSCD8EDAAAAtqjIgeqKe6q-BM4PeNmjHFgKHIWAziJxcgnrOuYInocFAAAAwXSuR_3WBkrdEV4proOm1YS4pBiX4uZI_KrNQfr24lv__________________________________________w2SsBq_3i0stplXyBZ3GUKRvdkkqMs1vSLIV4SGN95tAAAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAAN3h9dbyP8Gbj95RCnIpXwsfPf5Ge_JxbiSW7cuOIjQa"
           ],
           limit: 2,
           next: "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
         }}

      success_response2 =
        {:ok,
         %BlockHeaderResponse{
           items: [
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
           ],
           limit: 2,
           next: "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA"
         }}

      success_response3 =
        {:ok,
         %BlockHeaderResponse{
           items: [
             "AAAAAAAAAAC-CZT7WaIFAN3h9dbyP8Gbj95RCnIpXwsfPf5Ge_JxbiSW7cuOIjQaAwACAAAAOKrakx1LFapdQurxTNFb6qA4P-JxDu21DJuWNKzx9YQDAAAAo6s-Ne3AmA1EQpNYQFGm9FnuIVGJiyyeCkMKt9PxlwoFAAAAihn-S5iteAEmY3B8xTFU6oN_yX6V5-YxrR6UMNJDbhb__________________________________________0fwmB_uakipwfXi5V6Zcuw0RXT1KABdNlTSlNrl0fP9AAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAADOHaA_ozB8sYuE73wQ1Mt8fVTJHC8YJ6Y7b223dMlEA",
             "AAAAAAAAAACtzOT7WaIFADOHaA_ozB8sYuE73wQ1Mt8fVTJHC8YJ6Y7b223dMlEAAwACAAAA23466XpUOpH-JZHOVrRNp9ZEqreMZzHNEIf-UzQ-UsUDAAAAx-CiDTYa1ZKYVSoAPpkKfMw_kTQykpQBXa6eWl7ZABIFAAAAd3rPJIeypRDoJFTYB2BmKACVaFVfyd2AWTI7fCzUzFz__________________________________________7Q_YGBqE2V9U5LTP1etXXkkO6YuTfAz_mz4HsjpH-HIAAAAAAMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAAOJGiOVpPrd5rzWaAZlRAm5P8YHuUro61YdbPEvhhEii"
           ],
           limit: 2,
           next: "inclusive:jVP-BDWC93RfDzBVQxolPJi7RcX09ax1IMg0_I_MNIk"
         }}

      %{
        success_response: success_response,
        success_response2: success_response2,
        success_response3: success_response3
      }
    end

    test "success with Accept encode header", %{success_response: success_response} do
      ^success_response = BlockHeader.retrieve(query_params: [limit: 2])
    end

    test "success with Accept decode header", %{success_response2: success_response2} do
      ^success_response2 = BlockHeader.retrieve(format: :decode, query_params: [limit: 2])
    end

    test "success with all query params", %{success_response3: success_response3} do
      ^success_response3 =
        BlockHeader.retrieve(
          query_params: [
            limit: 2,
            next: "inclusive:M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
            minheight: 0,
            maxheight: 50_000
          ]
        )
    end

    test "error with an invalid next" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"invalid\\\".\""
       }} =
        BlockHeader.retrieve(
          query_params: [limit: 2, next: "invalid", minheight: 0, maxheight: 50_000]
        )
    end

    test "error with an invalid chain_id" do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockHeader.retrieve(network_id: :mainnet01, chain_id: "20")
    end

    test "error with a non existing location" do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        BlockHeader.retrieve(location: "col1", network_id: :mainnet01)
    end
  end

  describe "retrieve_by_hash/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedBlockHeaderRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      success_response_by_hash =
        {:ok,
         %BlockHeaderByHashResponse{
           item:
             "AAAAAAAAAAC-CZT7WaIFAN3h9dbyP8Gbj95RCnIpXwsfPf5Ge_JxbiSW7cuOIjQaAwACAAAAOKrakx1LFapdQurxTNFb6qA4P-JxDu21DJuWNKzx9YQDAAAAo6s-Ne3AmA1EQpNYQFGm9FnuIVGJiyyeCkMKt9PxlwoFAAAAihn-S5iteAEmY3B8xTFU6oN_yX6V5-YxrR6UMNJDbhb__________________________________________0fwmB_uakipwfXi5V6Zcuw0RXT1KABdNlTSlNrl0fP9AAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAHAAAACH1lqeSNBQAAAAAAAAAAADOHaA_ozB8sYuE73wQ1Mt8fVTJHC8YJ6Y7b223dMlEA"
         }}

      success_response_by_hash2 =
        {:ok,
         %BlockHeaderByHashResponse{
           item: %{
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
         }}

      success_response_by_hash3 =
        {:ok,
         %BlockHeaderByHashResponse{
           item:
             <<0, 0, 0, 0, 0, 0, 0, 0, 190, 9, 148, 251, 89, 162, 5, 0, 221, 225, 245, 214, 242,
               63, 193, 155, 143, 222, 81, 10, 114, 41, 95, 11, 31, 61, 254, 70, 123, 242, 113,
               110, 36, 150, 237, 203, 142, 34, 52, 26, 3, 0, 2, 0, 0, 0, 56, 170, 218, 147, 29,
               75, 21, 170, 93, 66, 234, 241, 76, 209, 91, 234, 160, 56, 63, 226, 113, 14, 237,
               181, 12, 155, 150, 52, 172, 241, 245, 132, 3, 0, 0, 0, 163, 171, 62, 53, 237, 192,
               152, 13, 68, 66, 147, 88, 64, 81, 166, 244, 89, 238, 33, 81, 137, 139, 44, 158, 10,
               67, 10, 183, 211, 241, 151, 10, 5, 0, 0, 0, 138, 25, 254, 75, 152, 173, 120, 1, 38,
               99, 112, 124, 197, 49, 84, 234, 131, 127, 201, 126, 149, 231, 230, 49, 173, 30,
               148, 48, 210, 67, 110, 22, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
               255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
               255, 255, 255, 255, 255, 71, 240, 152, 31, 238, 106, 72, 169, 193, 245, 226, 229,
               94, 153, 114, 236, 52, 69, 116, 245, 40, 0, 93, 54, 84, 210, 148, 218, 229, 209,
               243, 253, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 8, 125,
               101, 169, 228, 141, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 51, 135, 104, 15, 232, 204, 31,
               44, 98, 225, 59, 223, 4, 53, 50, 223, 31, 85, 50, 71, 11, 198, 9, 233, 142, 219,
               219, 109, 221, 50, 81, 0>>
         }}

      %{
        hash: "M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd0yUQA",
        success_response_by_hash: success_response_by_hash,
        success_response_by_hash2: success_response_by_hash2,
        success_response_by_hash3: success_response_by_hash3
      }
    end

    test "success with Accept encode header", %{
      hash: hash,
      success_response_by_hash: success_response_by_hash
    } do
      ^success_response_by_hash = BlockHeader.retrieve_by_hash(hash)
    end

    test "success with Accept decode header", %{
      hash: hash,
      success_response_by_hash2: success_response_by_hash2
    } do
      ^success_response_by_hash2 = BlockHeader.retrieve_by_hash(hash, format: :decode)
    end

    test "success with Accept binary header", %{
      hash: hash,
      success_response_by_hash3: success_response_by_hash3
    } do
      ^success_response_by_hash3 = BlockHeader.retrieve_by_hash(hash, format: :binary)
    end

    test "error with invalid hash" do
      {:error, %Error{status: 400, title: "DecodeException \"not enough bytes\""}} =
        BlockHeader.retrieve_by_hash("invalid")
    end

    test "error with a non existing hash" do
      {:error,
       %Error{
         status: 404,
         title:
           "{\"reason\":\"key not found\",\"key\":\"M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77774\"}"
       }} = BlockHeader.retrieve_by_hash("M4doD-jMHyxi4TvfBDUy3x9VMkcLxgnpjtvbbd77777")
    end

    test "error with invalid chain_id" do
      {:error, %Error{status: 404, title: "not found"}} =
        BlockHeader.retrieve_by_hash("invalid", chain_id: 21)
    end
  end
end
