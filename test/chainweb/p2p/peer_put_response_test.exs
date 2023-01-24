defmodule Kadena.Chainweb.P2P.PeerPutResponseTest do
  @moduledoc """
  `PeerPutResponse` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.PeerPutResponse
  alias Kadena.Chainweb.Peer

  setup do
    peer = %Peer{
      id: "PRLmVUcc9AH3fyfMYiWeC4nV2i1iHwc0-aM7iAO8h18",
      address: %{
        hostname: "85.238.99.91",
        port: 30_004
      }
    }

    peer_cut_response = %PeerPutResponse{peer: peer}

    %{
      peer: peer,
      peer_cut_response: peer_cut_response
    }
  end

  test "new/1", %{
    peer: peer,
    peer_cut_response: peer_cut_response
  } do
    ^peer_cut_response = PeerPutResponse.new(peer)
  end
end
