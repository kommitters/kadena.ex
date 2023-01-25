defmodule Kadena.Chainweb.P2P.PeerRequestBodyTest do
  @moduledoc """
  `PeerRequestBody` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.P2P.PeerRequestBody
  alias Kadena.Chainweb.Peer

  setup do
    address = %{
      hostname: "85.238.99.91",
      port: 30_004
    }

    id = "PRLmVUcc9AH3fyfMYiWeC4nV2i1iHwc0-aM7iAO8h18"

    peer =
      Peer.new(
        address: address,
        id: id
      )

    %{
      peer: peer,
      address: address,
      id: id
    }
  end

  describe "new/1" do
    test "with valid params", %{
      peer: peer,
      address: address,
      id: id
    } do
      %PeerRequestBody{
        address: ^address,
        id: ^id
      } = PeerRequestBody.new(peer)
    end

    test "with an invalid params" do
      {:error, [payload: :not_a_peer]} = PeerRequestBody.new("invalid")
    end
  end

  describe "to_json!/1" do
    setup do
      %{
        json_result:
          "{\"address\":{\"hostname\":\"85.238.99.91\",\"port\":30004},\"id\":\"PRLmVUcc9AH3fyfMYiWeC4nV2i1iHwc0-aM7iAO8h18\"}"
      }
    end

    test "with a valid PeerRequestBody", %{
      peer: peer,
      json_result: json_result
    } do
      ^json_result =
        peer
        |> PeerRequestBody.new()
        |> PeerRequestBody.to_json!()
    end
  end
end
