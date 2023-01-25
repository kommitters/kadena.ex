defmodule Kadena.Chainweb.P2P.PeerRequestBody do
  @moduledoc """
  `PeerRequestBody` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.Peer

  @type id :: String.t()
  @type address :: map()
  @type peer :: Peer.t()

  @type t :: %__MODULE__{
          address: address(),
          id: id()
        }
  defstruct [:id, :address]

  @impl true
  def new(%Peer{} = payload), do: build_peer_request_body(payload)
  def new(_payload), do: {:error, [payload: :not_a_peer]}

  @impl true
  def to_json!(%__MODULE__{
        id: id,
        address: address
      }),
      do:
        Jason.encode!(%{
          id: id,
          address: address
        })

  @spec build_peer_request_body(payload :: peer()) :: t()
  defp build_peer_request_body(%Peer{} = payload) do
    attrs = Map.from_struct(payload)
    struct(%__MODULE__{}, attrs)
  end
end
