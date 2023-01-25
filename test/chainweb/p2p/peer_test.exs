defmodule Kadena.Chainweb.Client.CannedPeerRequests do
  @moduledoc false

  alias Kadena.Chainweb.Error
  alias Kadena.Test.Fixtures.Chainweb

  def request(
        :get,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/cut/peer?limit=5",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("peer_retrieve_cut_info")
    {:ok, response}
  end

  def request(
        :get,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/cut/peer?limit=5&next=inclusive%3A5",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("peer_retrieve_cut_info_2")
    {:ok, response}
  end

  def request(
        :get,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/cut/peer?limit=f",
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
             "Error parsing query parameter limit failed: could not parse: `f' (input does not start with a digit)"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/cut/peer?limit=5&next=123",
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
             "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"123\\\".\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/cut/peer",
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
        :put,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/cut/peer",
        _headers,
        _body,
        _options
      ) do
    response = %{response: :no_content, status: 204}
    {:ok, response}
  end

  def request(
        :put,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/cut/peer",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: Chainweb.fixture("peer_retrieve_put_info")
         }}
      )

    {:error, response}
  end

  def request(
        :put,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/cut/peer",
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
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer?limit=2",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("peer_retrieve_mempool_info")
    {:ok, response}
  end

  def request(
        :get,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer?limit=2&next=inclusive%3A2",
        _headers,
        _body,
        _options
      ) do
    response = Chainweb.fixture("peer_retrieve_mempool_info_2")
    {:ok, response}
  end

  def request(
        :get,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer?limit=f",
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
             "Error parsing query parameter limit failed: could not parse: `f' (input does not start with a digit)"
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/mempool/peer?limit=2&next=123",
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
             "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"123\\\".\""
         }}
      )

    {:error, response}
  end

  def request(
        :get,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer",
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
        :put,
        "https://us-e1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer",
        _headers,
        _body,
        _options
      ) do
    response = %{response: :no_content, status: 204}
    {:ok, response}
  end

  def request(
        :put,
        "https://us1.testnet.chainweb.com/chainweb/0.0/testnet04/chain/0/mempool/peer",
        _headers,
        _body,
        _options
      ) do
    response =
      Error.new(
        {:chainweb,
         %{
           status: 400,
           title: Chainweb.fixture("peer_retrieve_put_info")
         }}
      )

    {:error, response}
  end

  def request(
        :put,
        "https://col1.chainweb.com/chainweb/0.0/mainnet01/chain/0/mempool/peer",
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
end

defmodule Kadena.Chainweb.P2P.PeerTest do
  @moduledoc """
  `Peer` endpoints implementation tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb
  alias Kadena.Chainweb.Client.CannedPeerRequests
  alias Kadena.Chainweb.Error
  alias Kadena.Chainweb.P2P.{Peer, PeerPutResponse, PeerResponse}

  describe "retrieve_cut_info/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedPeerRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %PeerResponse{
           items: [
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
           ],
           limit: 5,
           next: "inclusive:5"
         }}

      query_response =
        {:ok,
         %PeerResponse{
           items: [
             %{
               address: %{hostname: "202.61.244.124", port: 31_350},
               id: "NGWAyrXN7KTJ0pGCrSjepT2JIkmQoR3F6uShBakwogU"
             },
             %{
               address: %{hostname: "202.61.244.182", port: 31_350},
               id: "jzeetZdYpIVVMakXF3gPZewFvA2y7ITl-s9n88onPrk"
             },
             %{
               address: %{hostname: "34.68.148.186", port: 1789},
               id: "LeRJC7adbr2Mtbpo1jGJYST0X1_QKNBmXGVNApX-Edo"
             },
             %{
               address: %{hostname: "77.197.133.174", port: 31_350},
               id: "H807vFwc8mADojurOO93gT-KRTbEhClpmn6iu5t_cCA"
             },
             %{
               address: %{hostname: "35.76.76.135", port: 1789},
               id: "flE2czzEK67A22L7iz2qrWoYXkjqG0E9e1TNii-bXpE"
             }
           ],
           limit: 5,
           next: "inclusive:10"
         }}

      limit = 5
      next = "inclusive:5"

      %{
        response: response,
        query_response: query_response,
        limit: limit,
        next: next
      }
    end

    test "success", %{response: response} do
      ^response = Peer.retrieve_cut_info(network_id: :mainnet01, query_params: [limit: 5])
    end

    test "success with all query params", %{
      query_response: query_response,
      limit: limit,
      next: next
    } do
      ^query_response =
        Peer.retrieve_cut_info(
          network_id: :mainnet01,
          query_params: [limit: limit, next: next]
        )
    end

    test "error with a non existing location" do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Peer.retrieve_cut_info(location: "col1", network_id: :mainnet01)
    end

    test "error query params: invalid next value", %{limit: limit} do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"123\\\".\""
       }} =
        Peer.retrieve_cut_info(network_id: :testnet04, query_params: [limit: limit, next: 123])
    end

    test "error query params: invalid limit value" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter limit failed: could not parse: `f' (input does not start with a digit)"
       }} = Peer.retrieve_cut_info(network_id: :mainnet01, query_params: [limit: "f"])
    end
  end

  describe "put_cut_info/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedPeerRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %PeerPutResponse{
           peer: %Chainweb.Peer{
             address: %{hostname: "77.197.133.174", port: 31_350},
             id: "H807vFwc8mADojurOO93gT-KRTbEhClpmn6iu5t_cCA"
           }
         }}

      peer = %Chainweb.Peer{
        address: %{hostname: "77.197.133.174", port: 31_350},
        id: "H807vFwc8mADojurOO93gT-KRTbEhClpmn6iu5t_cCA"
      }

      response_peer_not_rechable =
        {:error,
         %Error{
           status: 400,
           title:
             "Invalid hostaddress: IsNotReachable (PeerInfo {_peerId = Just (PeerId \"\\US\\205;\\188\\\\\\FS\\242`\\ETX\\162;\\171\\&8\\239w\\129?\\138E6\\196\\132)i\\154~\\162\\187\\155\\DELp \"), _peerAddr = HostAddress {_hostAddressHost = 77.197.133.174, _hostAddressPort = 31350}}) \"\\\"HttpExceptionRequest Request {\\\\n  host                 = \\\\\\\"77.197.133.174\\\\\\\"\\\\n  port                 = 31350\\\\n  secure               = True\\\\n  requestHeaders       = [(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17.2\\\\\\\")]\\\\n  path                 = \\\\\\\"/chainweb/0.0/testnet04/cut/peer\\\\\\\"\\\\n  queryString          = \\\\\\\"\\\\\\\"\\\\n  method               = \\\\\\\"GET\\\\\\\"\\\\n  proxy                = Nothing\\\\n  rawBody              = False\\\\n  redirectCount        = 10\\\\n  responseTimeout      = ResponseTimeoutMicro 2000000\\\\n  requestVersion       = HTTP/1.1\\\\n  proxySecureMode      = ProxySecureWithConnect\\\\n}\\\\n (StatusCodeException (Response {responseStatus = Status {statusCode = 404, statusMessage = \\\\\\\"Not Found\\\\\\\"}, responseVersion = HTTP/1.1, responseHeaders = [(\\\\\\\"Transfer-Encoding\\\\\\\",\\\\\\\"chunked\\\\\\\"),(\\\\\\\"Date\\\\\\\",\\\\\\\"Tue, 24 Jan 2023 22:15:09 GMT\\\\\\\"),(\\\\\\\"Server\\\\\\\",\\\\\\\"Warp/3.3.23\\\\\\\"),(\\\\\\\"X-Server-Timestamp\\\\\\\",\\\\\\\"1674598509\\\\\\\"),(\\\\\\\"X-Peer-Addr\\\\\\\",\\\\\\\"34.86.6.55:35202\\\\\\\"),(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17\\\\\\\")], responseBody = (), responseCookieJar = CJ {expose = []}, responseClose' = ResponseClose, responseOriginalRequest = Request {\\\\n  host                 = \\\\\\\"77.197.133.174\\\\\\\"\\\\n  port                 = 31350\\\\n  secure               = True\\\\n  requestHeaders       = [(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17.2\\\\\\\")]\\\\n  path                 = \\\\\\\"/chainweb/0.0/testnet04/cut/peer\\\\\\\"\\\\n  queryString          = \\\\\\\"\\\\\\\"\\\\n  method               = \\\\\\\"GET\\\\\\\"\\\\n  proxy                = Nothing\\\\n  rawBody              = False\\\\n  redirectCount        = 10\\\\n  responseTimeout      = ResponseTimeoutMicro 2000000\\\\n  requestVersion       = HTTP/1.1\\\\n  proxySecureMode      = ProxySecureWithConnect\\\\n}\\\\n}) \\\\\\\"\\\\\\\")\\\"\""
         }}

      %{
        response: response,
        response_peer_not_rechable: response_peer_not_rechable,
        peer: peer
      }
    end

    test "success", %{response: response, peer: peer} do
      ^response = Peer.put_cut_info(peer, network_id: :mainnet01)
    end

    test "error peer not reachable.", %{
      peer: peer,
      response_peer_not_rechable: response_peer_not_rechable
    } do
      ^response_peer_not_rechable = Peer.put_cut_info(peer)
    end

    test "error not existing location", %{peer: peer} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Peer.put_cut_info(peer, location: "col1", network_id: :mainnet01)
    end
  end

  describe "retrieve_mempool_info/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedPeerRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %PeerResponse{
           items: [
             %{
               address: %{hostname: "65.109.23.84", port: 31_350},
               id: "MR1TFkDqCV557hwh1VOEJM1MfdFlOWt-ejpw58RwMzA"
             },
             %{
               address: %{hostname: "65.108.202.106", port: 31_350},
               id: "D0zC4BvxBseLKRljsyIHYkOtPLGkK96xfiE08yft34g"
             }
           ],
           limit: 2,
           next: "inclusive:2"
         }}

      query_response =
        {:ok,
         %Kadena.Chainweb.P2P.PeerResponse{
           items: [
             %{
               address: %{hostname: "65.108.9.161", port: 31_350},
               id: "_VA2_QqnUHXxekBiJT4ypxAi7znsR7oEsVRS_wk46nk"
             },
             %{
               address: %{hostname: "65.108.9.188", port: 31_350},
               id: "VQmD_ESHjDc_PBq15BShzJJZ74btZ_pIsK3jQSnXOkc"
             }
           ],
           limit: 2,
           next: "inclusive:4"
         }}

      limit = 2
      next = "inclusive:2"

      %{
        response: response,
        query_response: query_response,
        limit: limit,
        next: next
      }
    end

    test "success", %{response: response, limit: limit} do
      ^response = Peer.retrieve_mempool_info(network_id: :mainnet01, query_params: [limit: limit])
    end

    test "success with all query params", %{
      query_response: query_response,
      limit: limit,
      next: next
    } do
      ^query_response =
        Peer.retrieve_mempool_info(
          network_id: :mainnet01,
          query_params: [limit: limit, next: next]
        )
    end

    test "error with a non existing location" do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Peer.retrieve_mempool_info(location: "col1", network_id: :mainnet01)
    end

    test "error query params: invalid next value", %{limit: limit} do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter next failed: TextFormatException \"missing ':' in next item: \\\"123\\\".\""
       }} =
        Peer.retrieve_mempool_info(
          network_id: :testnet04,
          query_params: [limit: limit, next: 123]
        )
    end

    test "error query params: invalid limit value" do
      {:error,
       %Error{
         status: 400,
         title:
           "Error parsing query parameter limit failed: could not parse: `f' (input does not start with a digit)"
       }} = Peer.retrieve_mempool_info(network_id: :mainnet01, query_params: [limit: "f"])
    end
  end

  describe "put_mempool_info/1" do
    setup do
      Application.put_env(:kadena, :http_client_impl, CannedPeerRequests)

      on_exit(fn ->
        Application.delete_env(:kadena, :http_client_impl)
      end)

      response =
        {:ok,
         %PeerPutResponse{
           peer: %Chainweb.Peer{
             address: %{hostname: "77.197.133.174", port: 31_350},
             id: "H807vFwc8mADojurOO93gT-KRTbEhClpmn6iu5t_cCA"
           }
         }}

      peer = %Chainweb.Peer{
        address: %{hostname: "77.197.133.174", port: 31_350},
        id: "H807vFwc8mADojurOO93gT-KRTbEhClpmn6iu5t_cCA"
      }

      response_peer_not_rechable =
        {:error,
         %Error{
           status: 400,
           title:
             "Invalid hostaddress: IsNotReachable (PeerInfo {_peerId = Just (PeerId \"\\US\\205;\\188\\\\\\FS\\242`\\ETX\\162;\\171\\&8\\239w\\129?\\138E6\\196\\132)i\\154~\\162\\187\\155\\DELp \"), _peerAddr = HostAddress {_hostAddressHost = 77.197.133.174, _hostAddressPort = 31350}}) \"\\\"HttpExceptionRequest Request {\\\\n  host                 = \\\\\\\"77.197.133.174\\\\\\\"\\\\n  port                 = 31350\\\\n  secure               = True\\\\n  requestHeaders       = [(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17.2\\\\\\\")]\\\\n  path                 = \\\\\\\"/chainweb/0.0/testnet04/cut/peer\\\\\\\"\\\\n  queryString          = \\\\\\\"\\\\\\\"\\\\n  method               = \\\\\\\"GET\\\\\\\"\\\\n  proxy                = Nothing\\\\n  rawBody              = False\\\\n  redirectCount        = 10\\\\n  responseTimeout      = ResponseTimeoutMicro 2000000\\\\n  requestVersion       = HTTP/1.1\\\\n  proxySecureMode      = ProxySecureWithConnect\\\\n}\\\\n (StatusCodeException (Response {responseStatus = Status {statusCode = 404, statusMessage = \\\\\\\"Not Found\\\\\\\"}, responseVersion = HTTP/1.1, responseHeaders = [(\\\\\\\"Transfer-Encoding\\\\\\\",\\\\\\\"chunked\\\\\\\"),(\\\\\\\"Date\\\\\\\",\\\\\\\"Tue, 24 Jan 2023 22:15:09 GMT\\\\\\\"),(\\\\\\\"Server\\\\\\\",\\\\\\\"Warp/3.3.23\\\\\\\"),(\\\\\\\"X-Server-Timestamp\\\\\\\",\\\\\\\"1674598509\\\\\\\"),(\\\\\\\"X-Peer-Addr\\\\\\\",\\\\\\\"34.86.6.55:35202\\\\\\\"),(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17\\\\\\\")], responseBody = (), responseCookieJar = CJ {expose = []}, responseClose' = ResponseClose, responseOriginalRequest = Request {\\\\n  host                 = \\\\\\\"77.197.133.174\\\\\\\"\\\\n  port                 = 31350\\\\n  secure               = True\\\\n  requestHeaders       = [(\\\\\\\"X-Chainweb-Node-Version\\\\\\\",\\\\\\\"2.17.2\\\\\\\")]\\\\n  path                 = \\\\\\\"/chainweb/0.0/testnet04/cut/peer\\\\\\\"\\\\n  queryString          = \\\\\\\"\\\\\\\"\\\\n  method               = \\\\\\\"GET\\\\\\\"\\\\n  proxy                = Nothing\\\\n  rawBody              = False\\\\n  redirectCount        = 10\\\\n  responseTimeout      = ResponseTimeoutMicro 2000000\\\\n  requestVersion       = HTTP/1.1\\\\n  proxySecureMode      = ProxySecureWithConnect\\\\n}\\\\n}) \\\\\\\"\\\\\\\")\\\"\""
         }}

      %{
        response: response,
        response_peer_not_rechable: response_peer_not_rechable,
        peer: peer
      }
    end

    test "success", %{response: response, peer: peer} do
      ^response = Peer.put_mempool_info(peer, network_id: :mainnet01)
    end

    test "error peer not reachable.", %{
      peer: peer,
      response_peer_not_rechable: response_peer_not_rechable
    } do
      ^response_peer_not_rechable = Peer.put_mempool_info(peer)
    end

    test "error with a non existing location", %{peer: peer} do
      {:error, %Error{status: :network_error, title: :nxdomain}} =
        Peer.put_mempool_info(peer, location: "col1", network_id: :mainnet01)
    end
  end
end
