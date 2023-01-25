defmodule Kadena.Chainweb.PeerTest do
  @moduledoc """
  `Peer` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Peer

  setup do
    address = %{
      hostname: "85.238.99.91",
      port: 30_004
    }

    id = "PRLmVUcc9AH3fyfMYiWeC4nV2i1iHwc0-aM7iAO8h18"

    invalid_address = %{
      hostname: 123,
      port: "30_004"
    }

    %{
      address: address,
      id: id,
      invalid_address: invalid_address
    }
  end

  describe "create Peer" do
    test "with valid Keyword args", %{
      address: address,
      id: id
    } do
      %Peer{
        address: ^address,
        id: ^id
      } =
        Peer.new(
          address: address,
          id: id
        )
    end

    test "with a valid pipe creation", %{
      address: address,
      id: id
    } do
      %Peer{
        address: ^address,
        id: ^id
      } =
        Peer.new()
        |> Peer.set_id(id)
        |> Peer.set_address(address)
    end

    test "with a nil id", %{
      address: address
    } do
      %Peer{
        address: ^address,
        id: nil
      } =
        Peer.new()
        |> Peer.set_id(nil)
        |> Peer.set_address(address)
    end

    test "with an invalid address: not a map" do
      {:error, [address: :not_a_map]} = Peer.set_address(Peer.new(), "invalid_value")
    end

    test "with an invalid address: invalid content", %{invalid_address: invalid_address} do
      {:error, [address: [args: :invalid]]} = Peer.set_address(Peer.new(), invalid_address)
    end

    test "with an invalid id" do
      {:error, [id: :invalid]} = Peer.set_id(Peer.new(), 123)
    end
  end
end
