defmodule Kadena.Chainweb.P2P.CutRequestBody do
  @moduledoc """
  `CutRequestBody` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.P2P.CutResponse

  @type hashes :: map()
  @type height :: non_neg_integer()
  @type id :: String.t()
  @type instance :: String.t()
  @type weight :: String.t()
  @type origin :: map() | nil
  @type cut_response :: CutResponse.t()

  @type t :: %__MODULE__{
          hashes: hashes(),
          height: height(),
          weight: weight(),
          origin: origin(),
          id: id(),
          instance: instance()
        }
  defstruct [:hashes, :height, :weight, :id, :instance, :origin]

  @impl true
  def new(%CutResponse{} = payload), do: build_local_request_body(payload)
  def new(_payload), do: {:error, [payload: :not_a_cut_response]}

  @impl true
  def to_json!(%__MODULE__{
        hashes: hashes,
        height: height,
        weight: weight,
        origin: origin,
        id: id,
        instance: instance
      }),
      do:
        Jason.encode!(%{
          hashes: hashes,
          height: height,
          weight: weight,
          origin: origin,
          id: id,
          instance: instance
        })

  @spec set_origin(payload :: t(), origin :: origin()) :: t()
  def set_origin(%__MODULE__{} = payload, origin), do: %{payload | origin: origin}

  @spec build_local_request_body(payload :: cut_response()) :: t()
  defp build_local_request_body(%CutResponse{} = payload) do
    attrs = Map.from_struct(payload)
    struct(%__MODULE__{}, attrs)
  end
end
