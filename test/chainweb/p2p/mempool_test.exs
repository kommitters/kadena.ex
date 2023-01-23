defmodule Kadena.Chainweb.Client.CannedMempoolRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :post,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/getPending",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("mempool_retrieve_tx")
    {:ok, response}
  end

  def request(
        :post,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/mempool/getPending",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("mempool_retrieve_tx_3")
    {:ok, response}
  end

  def request(
        :post,
        "https://jp2.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/getPending?nonce=1585882245418157&since=20160180",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("mempool_retrieve_tx_2")
    {:ok, response}
  end

  def request(
        :post,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/getPending?nonce=f",
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
             "Error parsing query parameter nonce failed: could not parse: `f' (input does not start with a digit)"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/getPending",
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
        :post,
        "https://jp1.chainweb.com/chainweb/0.0/mainnet01/chain/20/mempool/getPending",
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

defmodule Kadena.Chainweb.P2P.MempoolTest do
  @moduledoc """
  `Mempool` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb
  alias Kadena.Chainweb.Client.CannedMempoolRequests
  alias Kadena.Chainweb.P2P.{Mempool, MempoolResponse}

  describe "retrieve_pending_txs/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedMempoolRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response_mainnet =
        {:ok,
         %MempoolResponse{
           hashes: [
             "bCBI9Z9RvNLoPX6J8UMwW3a09I6z9_IP7dN0NAGsFfw",
             "vArBe6MHlLzJjp3QC7vlincur9muOjX9tSTrHjon43M",
             "TUEEckWQHHCvdCtg9cwLRmpndhUN8apPle0NfPWMLIM",
             "XdZZj9uIDCQ3F8ojZioJlYU7vWCskmb3_r43X4dDUPU",
             "ndeArlCWEoarNaM_LA9MLjzB8w58iaDmmRPeejW3xDs",
             "n9ZOM0kR5siGLFtzw7UUcv29vPUxlZzfw-JvwDKzbxk",
             "WPUl824g04OfI8XvKWccqGk6rP1hYjf9wSYuf7yNbrU",
             "uaoMedrv27uUHJI2xzBy2u-4Kk_jy04WBuFk_eDVpEU",
             "mV6ohfmJYPEYKFYfcJH8j-aEgEiqdcze-qab2Nf4SLs",
             "CtAfH2tvBIFKXLoRQazUJGd1Mu0L2ED6rEdF-WMHdfQ",
             "ul3ZSjlLOtGCJrUzt4-Jceb71pm0rITvdhbfZkxx5Pk",
             "C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo",
             "i5mAEmrcpP0PrHWubldicog9atWwq0-6IO9Nof0hFsk",
             "FLk5gjAAAnv1T7YIuRzUDJXiz4XAIDk_Xymn3-i0P1k",
             "RMHKxYF7xIH5hHeu1ZghvlLMS0TtXztEOjUATws0U7c",
             "lKQ3pUNhsk8XCUdNF7GJvgFqYD5ebFCdgat7KA5tpKA",
             "1N_bL1WLyxXaEJDUS9lZn9rp0jE-emwO7AWaLUBPZ6s",
             "NU6WHomGhEZ7unbZR08ll0-IDN2yEMJ60WqdPVrJ89U",
             "EdfVWyS5yDGdlPQu1SuwN4zvwrXPiMsjfXikFHO5Psg",
             "cVDbNODyPk38DgX5LotmXmiXuommel7K5zq10sTwwTA",
             "A2AN30N4yQS5RM_EZUwMXkLtZqWFrPkDE89qVk4QHKs",
             "Q1HMRaU95xNqq9NxViH9XzxStG2W32gRLCsOG3UIbBo",
             "o_mdmShUDKoqpOS7zFafDYYGzPXaRD8ydDGNKmqG9kk"
           ],
           highwater_mark: [-2_247_324_167_920_489_014, 70_266]
         }}

      response_testnet =
        {:ok,
         %MempoolResponse{
           hashes: [],
           highwater_mark: [2_619_999_507_090_149_325, 866]
         }}

      query_response =
        {:ok,
         %MempoolResponse{
           hashes: [
             "LB0ZmDAhkiY6y0bp8H5UF8au9VGW8eFABh-cpwQ-Y1M",
             "nFFmcUPBoJRqNQ2_Iqt7xkA1Dr_wiQHE5QTsdPwyhZU",
             "HQt4JFBHyeHZdAMqKujsMbQ8LDUtDTWNdTrmkdc7Cjs",
             "TSCgWlTi0OZVp6VnKlOvFhFcKGAiOfTbHcupCqZ5e24",
             "OR5Dse8kL-nKSe7ZF0KHC8F1CNoQknQCsw3whpgidsU",
             "SYDCajc47blZQpdJ_3v3PF_mSPBJy0hzGTo7NaxcM9U",
             "eprG2VuznDLZSoQ57d3m0G5Wallx1ZQ0GPXvGLKWcZM",
             "mkmpB_yQRrFgjJPOj3mxOOEpKTdpObpXRkO-1SYGiQo",
             "-t8sh5gJwN-YaRgfYzI-vz9ohuOMF_UswaIxr-KnzVo",
             "C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo",
             "C43gu7BEEDekwUqxClYh_jjwFqmgbfmCXOC_1qZ5iE0",
             "NU6WHomGhEZ7unbZR08ll0-IDN2yEMJ60WqdPVrJ89U",
             "lb57c9u0OPDwRTtU2GCHx5LZVaRpCa8qIBQ9MWKLKOI",
             "kEbHkhr6rVfvHu8jOd15OEOsjxiDJHoTPT3_OdXD7xc",
             "wB2F6OX3tP-DSHBNfj6C-pAr579MEm8CK2VOqe5JUHo",
             "wgIE0iLcspTyhkYCj1eeELBvRnydOYf8XKSgl9Us6Sw",
             "s1O36uLp70lVNxgFlabizRXxYw_oy-uJ6E94PZG1Z24",
             "88P6Tc_SAEaramRMYu99tEzCU2r0qTf0d1zFF_IZc4c"
           ],
           highwater_mark: [-6_584_275_415_170_549_274, 131_499]
         }}

      %{
        response_mainnet: response_mainnet,
        response_testnet: response_testnet,
        query_response: query_response
      }
    end

    test "success mainnet", %{response_mainnet: response_mainnet} do
      ^response_mainnet = Mempool.retrieve_pending_txs(network_id: :mainnet01)
    end

    test "success testnet", %{response_testnet: response_testnet} do
      ^response_testnet = Mempool.retrieve_pending_txs()
    end

    test "success with location and query params", %{query_response: query_response} do
      ^query_response =
        Mempool.retrieve_pending_txs(
          location: "jp2",
          network_id: :mainnet01,
          query_params: [nonce: 1_585_882_245_418_157, since: 20_160_180]
        )
    end

    test "error with a non existing location" do
      {:error, %Chainweb.Error{status: :network_error, title: :nxdomain}} =
        Mempool.retrieve_pending_txs(location: "col1", network_id: :mainnet01)
    end

    test "error with an invalid query params value" do
      {:error,
       %Chainweb.Error{
         status: 400,
         title:
           "Error parsing query parameter nonce failed: could not parse: `f' (input does not start with a digit)"
       }} = Mempool.retrieve_pending_txs(network_id: :mainnet01, query_params: [nonce: "f"])
    end

    test "error with an invalid chain_id" do
      {:error, %Chainweb.Error{status: 404, title: "not found"}} =
        Mempool.retrieve_pending_txs(location: "jp1", network_id: :mainnet01, chain_id: 20)
    end
  end
end
