defmodule Kadena.Chainweb.Client.CannedBlockHeaderRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
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
end

defmodule Kadena.Chainweb.P2P.BlockHeaderTest do
  @moduledoc """
  `BlockHeader` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Client.CannedBlockHeaderRequests
  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.{BlockHeader, BlockHeaderResponse}

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
       %Kadena.Chainweb.P2P.BlockHeaderResponse{
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

  describe "retrieve/1" do
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
end
