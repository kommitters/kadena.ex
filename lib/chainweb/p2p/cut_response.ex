defmodule Kadena.Chainweb.P2P.CutResponse do
  @moduledoc """
  `CutResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type hashes :: map()
  @type height :: non_neg_integer()
  @type id :: String.t()
  @type instance :: String.t()
  @type origin :: map() | nil
  @type weight :: String.t()

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
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
