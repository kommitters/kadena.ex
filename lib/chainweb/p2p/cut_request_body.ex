defmodule Kadena.Chainweb.P2P.CutRequestBody do
  @moduledoc """
  `CutRequestBody` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  alias Kadena.Chainweb.Cut

  @type hashes :: map()
  @type height :: non_neg_integer()
  @type id :: String.t()
  @type instance :: String.t()
  @type weight :: String.t()
  @type origin :: map() | nil
  @type cut :: Cut.t()

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
  def new(%Cut{} = payload), do: build_cut_request_body(payload)
  def new(_payload), do: {:error, [payload: :not_a_cut]}

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

  @spec build_cut_request_body(payload :: cut()) :: t()
  defp build_cut_request_body(%Cut{} = payload) do
    attrs = Map.from_struct(payload)
    struct(%__MODULE__{}, attrs)
  end
end
