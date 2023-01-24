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
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/member",
        _headers,
        "[123]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error in $[0]: parsing TransactionHash failed, expected String, but encountered Number"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/member",
        _headers,
        "[\"invalid\"]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "not enough bytes\nCallStack (from HasCallStack):\n  error, called at src/Chainweb/Mempool/Mempool.hs:574:25 in chainweb-2.17.2-inplace:Chainweb.Mempool.Mempool"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/member",
        _headers,
        "[\"C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo\",\"hK1dutkawvL5Pt79rMzA8JnQZyUesAY0ce8XL0sHIqc\"]",
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
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/member",
        _headers,
        _body,
        _options
      ) do
    response = [true, false]

    {:ok, response}
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

  def request(
        :post,
        "https://jp1.chainweb.com/chainweb/0.0/mainnet01/chain/20/mempool/member",
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
        :post,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/lookup",
        _headers,
        "[123]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "Error in $[0]: parsing TransactionHash failed, expected String, but encountered Number"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/lookup",
        _headers,
        "[\"invalid\"]",
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title:
             "not enough bytes\nCallStack (from HasCallStack):\n  error, called at src/Chainweb/Mempool/Mempool.hs:574:25 in chainweb-2.17.2-inplace:Chainweb.Mempool.Mempool"
         }}
      )

    {:error, response}
  end

  def request(
        :post,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/lookup",
        _headers,
        "[\"C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo\",\"hK1dutkawvL5Pt79rMzA8JnQZyUesAY0ce8XL0sHIqc\"]",
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
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/lookup",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("mempool_lookup")

    {:ok, response}
  end

  def request(
        :post,
        "https://jp1.chainweb.com/chainweb/0.0/mainnet01/chain/20/mempool/lookup",
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

  alias Kadena.Chainweb.Client.CannedMempoolRequests
  alias Kadena.Chainweb.Error

  alias Kadena.Chainweb.P2P.{
    Mempool,
    MempoolCheckResponse,
    MempoolLookupResponse,
    MempoolRetrieveResponse
  }

  describe "retrieve_pending_txs/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedMempoolRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response_mainnet =
        {:ok,
         %MempoolRetrieveResponse{
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
         %MempoolRetrieveResponse{
           hashes: [],
           highwater_mark: [2_619_999_507_090_149_325, 866]
         }}

      query_response =
        {:ok,
         %MempoolRetrieveResponse{
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
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Mempool.retrieve_pending_txs(location: "col1", network_id: :mainnet01)
    end

    test "error with an invalid query params value" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter nonce failed: could not parse: `f' (input does not start with a digit)"
       }} = Mempool.retrieve_pending_txs(network_id: :mainnet01, query_params: [nonce: "f"])
    end

    test "error with an invalid chain_id" do
      {:error, %Error{status: 404, title: "not found"}} =
        Mempool.retrieve_pending_txs(location: "jp1", network_id: :mainnet01, chain_id: 20)
    end
  end

  describe "check_pending_txs/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedMempoolRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response = {:ok, %MempoolCheckResponse{results: [true, false]}}

      request_keys = [
        "C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo",
        "hK1dutkawvL5Pt79rMzA8JnQZyUesAY0ce8XL0sHIqc"
      ]

      %{
        response: response,
        request_keys: request_keys
      }
    end

    test "success", %{request_keys: request_keys, response: response} do
      ^response = Mempool.check_pending_txs(request_keys, network_id: :mainnet01)
    end

    test "error with a non existing location", %{request_keys: request_keys} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Mempool.check_pending_txs(request_keys, location: "col1", network_id: :mainnet01)
    end

    test "error with an invalid size in request_keys" do
      {:error,
       %Error{
         status: 400,
         title:
           "not enough bytes\nCallStack (from HasCallStack):\n  error, called at src/Chainweb/Mempool/Mempool.hs:574:25 in chainweb-2.17.2-inplace:Chainweb.Mempool.Mempool"
       }} = Mempool.check_pending_txs(["invalid"], network_id: :mainnet01)
    end

    test "error with an invalid format in request_keys" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error in $[0]: parsing TransactionHash failed, expected String, but encountered Number"
       }} = Mempool.check_pending_txs([123], network_id: :mainnet01)
    end

    test "error with an invalid chain_id", %{request_keys: request_keys} do
      {:error, %Error{status: 404, title: "not found"}} =
        Mempool.check_pending_txs(request_keys,
          location: "jp1",
          network_id: :mainnet01,
          chain_id: 20
        )
    end
  end

  describe "lookup_pending_txs/2" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedMempoolRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %MempoolLookupResponse{
           results: [
             %{
               contents:
                 "{\"hash\":\"C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo\",\"sigs\":[],\"cmd\":\"{\\\"networkId\\\":\\\"mainnet01\\\",\\\"payload\\\":{\\\"cont\\\":{\\\"proof\\\":\\\"eyJjaGFpbiI6MCwib2JqZWN0IjoiQUFBQUVRQUFBQUFBQUFBQ0FNQldwNWtIdGs2bnpxVXVJMzhIdlZ5bUNaS21BUU9DMlp1RHFqWEx1Z3VjQUxvcTk2R0lsZGlaSnNNYnI5Y0VTYl9Gam9TVlI0QTRBMThQNS0zVnl2OFRBVjhtRkcyc1RyVVN5bGVzVmlqWUxVVmFWSE1wbE1zRlhPRHRyTGNYOVdxbkFhOVk3eFVXSUN2cmVMSmctZVpGQWQ0aDAtbFlUVVFydkZiQl9tZnNMaWRQQUUzWXh0WHJJcl9qenpUbkhuOWdCd0Vrc19EUzZtUXBmblZ0dEIySVFCRUVBYUtsZ05mdFd6VGpib2xWS0tBNDBIWDltTUxkZU44TzJnSm5HZm9jMlpsT0FJUlZWcU9ULXlDSjFaSC1qWGJMVzB6X21MUlB2QVZtblJCS3NiZnF1VlZ3QUtzN0lCTFN4M2VtOFdFSS1RV3k1UEI3bDY3QUpzZ2NoemxzV21FUjBiUVhBZWpZUEFmUm5ONDByUExfZ1QtUHpnZVZzU1A0VEtqcXVlaVdTQjZUc3M0bEFMaG04bFFSdFFKSkV4bVJtRTZZU0lFeE1VM2w5UkVQT0ZFN3lDcHc4MTE2QWVYWHhGcFJMUlh4ZWlranR3QnpteS1HZ1FMVnUwQVpSbnpJa1hUcS02bnRBQUpvSVl4Rjloeld5Zjc1VVJlUFJ2enV1eW1ZUjRDdkI2OW1laHR5UnBLUUFGRUZDMVdMY2Z4bWNCeG5la21yUnFtcUV1Qlk2eXZvWEg2T2NaeVRFX2xoQUV5cVlxekZDdUZCWXhCMkJXOWJPYjF3dnF1U1l5QmNQMFR6MElkYTlVYUVBSGJKeWxyU01TYzRNMTdKMjRXTU1TYV9HNFp5Sjc0ampIVWkzbTdPT0RfdUFYdlNrWTlvbjRlaHI5ZmlvN1puTUJnTlRlSFM1S1hqRVBZTjFGNGV3SllBQUFnWU94eWdYV2NKeTBQakppa0hERnpkbkVGVDdXX3k3am50SnBtYU0wejMiLCJzdWJqZWN0Ijp7ImlucHV0IjoiQUJSN0ltZGhjeUk2TmpJeExDSnlaWE4xYkhRaU9uc2ljM1JoZEhWeklqb2ljM1ZqWTJWemN5SXNJbVJoZEdFaU9uc2lZVzF2ZFc1MElqb3lMakV5T1RZd056Z3pMQ0p5WldObGFYWmxjaUk2SW1zNk1UQmpNakExT1Rrd05XUXpOR1ptWVRrMVpEUXdORGs1TlRReE1ESmhOV1EzWlRrd1lXRXdNekptTldFM05UTTJOakZqWm1Fek1UZ3pNVGt5T0RVMk5DSXNJbk52ZFhKalpTMWphR0ZwYmlJNklqSWlMQ0p5WldObGFYWmxjaTFuZFdGeVpDSTZleUp3Y21Wa0lqb2lhMlY1Y3kxaGJHd2lMQ0pyWlhseklqcGJJakV3WXpJd05UazVNRFZrTXpSbVptRTVOV1EwTURRNU9UVTBNVEF5WVRWa04yVTVNR0ZoTURNeVpqVmhOelV6TmpZeFkyWmhNekU0TXpFNU1qZzFOalFpWFgxOWZTd2ljbVZ4UzJWNUlqb2lXa3gxV1MxM05uUTNkMmwxV1UxT1NUUjJhVnA0VkVveE5uVm9kMEpJUlVzNVNsaG9XR051UzNWUU1DSXNJbXh2WjNNaU9pSnpRaTFGVFdSUlgyVTViMlp2U1ZOT2RXc3hlVXh1YTB4UlZqUTRkMHc0ZVdaNGQzRXlRamhsYlROTklpd2laWFpsYm5SeklqcGJleUp3WVhKaGJYTWlPbHNpYXpveE1HTXlNRFU1T1RBMVpETTBabVpoT1RWa05EQTBPVGsxTkRFd01tRTFaRGRsT1RCaFlUQXpNbVkxWVRjMU16WTJNV05tWVRNeE9ETXhPVEk0TlRZMElpd2lPVGxqWWpjd01EaGtOMlEzTUdNNU5HWXhNemhqWXpNMk5tRTRNalZtTUdRNVl6Z3pZVGhoTW1ZMFltRTRNbU00Tm1NMk5qWmxNR0ZpTm1abFkyWXpZU0lzTmk0eU1XVXRObDBzSW01aGJXVWlPaUpVVWtGT1UwWkZVaUlzSW0xdlpIVnNaU0k2ZXlKdVlXMWxjM0JoWTJVaU9tNTFiR3dzSW01aGJXVWlPaUpqYjJsdUluMHNJbTF2WkhWc1pVaGhjMmdpT2lKeVJUZEVWVGhxYkZGTU9YaGZUVkJaZFc1cFdrcG1OVWxEUWxSQlJVaEJTVVpSUTBJMFlteHZabEEwSW4wc2V5SndZWEpoYlhNaU9sc2lhem94TUdNeU1EVTVPVEExWkRNMFptWmhPVFZrTkRBME9UazFOREV3TW1FMVpEZGxPVEJoWVRBek1tWTFZVGMxTXpZMk1XTm1ZVE14T0RNeE9USTROVFkwSWl3aWF6b3hNR015TURVNU9UQTFaRE0wWm1aaE9UVmtOREEwT1RrMU5ERXdNbUUxWkRkbE9UQmhZVEF6TW1ZMVlUYzFNelkyTVdObVlUTXhPRE14T1RJNE5UWTBJaXd5TGpFeU9UWXdOemd6TENJd0lsMHNJbTVoYldVaU9pSlVVa0ZPVTBaRlVsOVlRMGhCU1U0aUxDSnRiMlIxYkdVaU9uc2libUZ0WlhOd1lXTmxJanB1ZFd4c0xDSnVZVzFsSWpvaVkyOXBiaUo5TENKdGIyUjFiR1ZJWVhOb0lqb2lja1UzUkZVNGFteFJURGw0WDAxUVdYVnVhVnBLWmpWSlEwSlVRVVZJUVVsR1VVTkNOR0pzYjJaUU5DSjlMSHNpY0dGeVlXMXpJanBiSW1zNk1UQmpNakExT1Rrd05XUXpOR1ptWVRrMVpEUXdORGs1TlRReE1ESmhOV1EzWlRrd1lXRXdNekptTldFM05UTTJOakZqWm1Fek1UZ3pNVGt5T0RVMk5DSXNJaUlzTWk0eE1qazJNRGM0TTEwc0ltNWhiV1VpT2lKVVVrRk9VMFpGVWlJc0ltMXZaSFZzWlNJNmV5SnVZVzFsYzNCaFkyVWlPbTUxYkd3c0ltNWhiV1VpT2lKamIybHVJbjBzSW0xdlpIVnNaVWhoYzJnaU9pSnlSVGRFVlRocWJGRk1PWGhmVFZCWmRXNXBXa3BtTlVsRFFsUkJSVWhCU1VaUlEwSTBZbXh2WmxBMEluMHNleUp3WVhKaGJYTWlPbHNpTUNJc0ltTnZhVzR1ZEhKaGJuTm1aWEl0WTNKdmMzTmphR0ZwYmlJc1d5SnJPakV3WXpJd05UazVNRFZrTXpSbVptRTVOV1EwTURRNU9UVTBNVEF5WVRWa04yVTVNR0ZoTURNeVpqVmhOelV6TmpZeFkyWmhNekU0TXpFNU1qZzFOalFpTENKck9qRXdZekl3TlRrNU1EVmtNelJtWm1FNU5XUTBNRFE1T1RVME1UQXlZVFZrTjJVNU1HRmhNRE15WmpWaE56VXpOall4WTJaaE16RTRNekU1TWpnMU5qUWlMSHNpY0hKbFpDSTZJbXRsZVhNdFlXeHNJaXdpYTJWNWN5STZXeUl4TUdNeU1EVTVPVEExWkRNMFptWmhPVFZrTkRBME9UazFOREV3TW1FMVpEZGxPVEJoWVRBek1tWTFZVGMxTXpZMk1XTm1ZVE14T0RNeE9USTROVFkwSWwxOUxDSXdJaXd5TGpFeU9UWXdOemd6WFYwc0ltNWhiV1VpT2lKWVgxbEpSVXhFSWl3aWJXOWtkV3hsSWpwN0ltNWhiV1Z6Y0dGalpTSTZiblZzYkN3aWJtRnRaU0k2SW5CaFkzUWlmU3dpYlc5a2RXeGxTR0Z6YUNJNkluSkZOMFJWT0dwc1VVdzVlRjlOVUZsMWJtbGFTbVkxU1VOQ1ZFRkZTRUZKUmxGRFFqUmliRzltVURRaWZWMHNJbTFsZEdGRVlYUmhJanB1ZFd4c0xDSmpiMjUwYVc1MVlYUnBiMjRpT25zaVpYaGxZM1YwWldRaU9tNTFiR3dzSW5CaFkzUkpaQ0k2SWxwTWRWa3RkelowTjNkcGRWbE5Ua2swZG1sYWVGUktNVFoxYUhkQ1NFVkxPVXBZYUZoamJrdDFVREFpTENKemRHVndTR0Z6VW05c2JHSmhZMnNpT21aaGJITmxMQ0p6ZEdWd0lqb3dMQ0o1YVdWc1pDSTZleUprWVhSaElqcDdJbUZ0YjNWdWRDSTZNaTR4TWprMk1EYzRNeXdpY21WalpXbDJaWElpT2lKck9qRXdZekl3TlRrNU1EVmtNelJtWm1FNU5XUTBNRFE1T1RVME1UQXlZVFZrTjJVNU1HRmhNRE15WmpWaE56VXpOall4WTJaaE16RTRNekU1TWpnMU5qUWlMQ0p6YjNWeVkyVXRZMmhoYVc0aU9pSXlJaXdpY21WalpXbDJaWEl0WjNWaGNtUWlPbnNpY0hKbFpDSTZJbXRsZVhNdFlXeHNJaXdpYTJWNWN5STZXeUl4TUdNeU1EVTVPVEExWkRNMFptWmhPVFZrTkRBME9UazFOREV3TW1FMVpEZGxPVEJoWVRBek1tWTFZVGMxTXpZMk1XTm1ZVE14T0RNeE9USTROVFkwSWwxOWZTd2ljMjkxY21ObElqb2lNaUlzSW5CeWIzWmxibUZ1WTJVaU9uc2lkR0Z5WjJWMFEyaGhhVzVKWkNJNklqQWlMQ0p0YjJSMWJHVklZWE5vSWpvaWNrVTNSRlU0YW14UlREbDRYMDFRV1hWdWFWcEtaalZKUTBKVVFVVklRVWxHVVVOQ05HSnNiMlpRTkNKOWZTd2lZMjl1ZEdsdWRXRjBhVzl1SWpwN0ltRnlaM01pT2xzaWF6b3hNR015TURVNU9UQTFaRE0wWm1aaE9UVmtOREEwT1RrMU5ERXdNbUUxWkRkbE9UQmhZVEF6TW1ZMVlUYzFNelkyTVdObVlUTXhPRE14T1RJNE5UWTBJaXdpYXpveE1HTXlNRFU1T1RBMVpETTBabVpoT1RWa05EQTBPVGsxTkRFd01tRTFaRGRsT1RCaFlUQXpNbVkxWVRjMU16WTJNV05tWVRNeE9ETXhPVEk0TlRZMElpeDdJbkJ5WldRaU9pSnJaWGx6TFdGc2JDSXNJbXRsZVhNaU9sc2lNVEJqTWpBMU9Ua3dOV1F6TkdabVlUazFaRFF3TkRrNU5UUXhNREpoTldRM1pUa3dZV0V3TXpKbU5XRTNOVE0yTmpGalptRXpNVGd6TVRreU9EVTJOQ0pkZlN3aU1DSXNNaTR4TWprMk1EYzRNMTBzSW1SbFppSTZJbU52YVc0dWRISmhibk5tWlhJdFkzSnZjM05qYUdGcGJpSjlMQ0p6ZEdWd1EyOTFiblFpT2pKOUxDSjBlRWxrSWpvMk1UWXlNVEV5ZlEifSwiYWxnb3JpdGhtIjoiU0hBNTEydF8yNTYifQ\\\",\\\"pactId\\\":\\\"ZLuY-w6t7wiuYMNI4viZxTJ16uhwBHEK9JXhXcnKuP0\\\",\\\"rollback\\\":false,\\\"step\\\":1,\\\"data\\\":{}}},\\\"signers\\\":[],\\\"meta\\\":{\\\"creationTime\\\":1674478129,\\\"ttl\\\":28800,\\\"gasLimit\\\":300,\\\"chainId\\\":\\\"0\\\",\\\"gasPrice\\\":1e-8,\\\"sender\\\":\\\"kadena-xchain-gas\\\"},\\\"nonce\\\":\\\"\\\\\\\"2023-01-23T12:49:04.486Z\\\\\\\"\\\"}\"}",
               tag: "Pending"
             },
             %{
               tag: "Missing"
             }
           ]
         }}

      request_keys = [
        "C385m6e9S7WzelUFCyW-JoZFJGQNlcI0jqCO8YrPMVo",
        "hK1dutkawvL5Pt79rMzA8JnQZyUesAY0ce8XL0sHIqc"
      ]

      %{
        response: response,
        request_keys: request_keys
      }
    end

    test "success", %{request_keys: request_keys, response: response} do
      ^response = Mempool.lookup_pending_txs(request_keys, network_id: :mainnet01)
    end

    test "error with a non existing location", %{request_keys: request_keys} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Mempool.lookup_pending_txs(request_keys, location: "col1", network_id: :mainnet01)
    end

    test "error with an invalid size in request_keys" do
      {:error,
       %Error{
         status: 400,
         title:
           "not enough bytes\nCallStack (from HasCallStack):\n  error, called at src/Chainweb/Mempool/Mempool.hs:574:25 in chainweb-2.17.2-inplace:Chainweb.Mempool.Mempool"
       }} = Mempool.lookup_pending_txs(["invalid"], network_id: :mainnet01)
    end

    test "error with an invalid format in request_keys" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error in $[0]: parsing TransactionHash failed, expected String, but encountered Number"
       }} = Mempool.lookup_pending_txs([123], network_id: :mainnet01)
    end

    test "error with an invalid chain_id", %{request_keys: request_keys} do
      {:error, %Error{status: 404, title: "not found"}} =
        Mempool.lookup_pending_txs(request_keys,
          location: "jp1",
          network_id: :mainnet01,
          chain_id: 20
        )
    end
  end
end
