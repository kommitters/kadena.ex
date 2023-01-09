defmodule Kadena.Chainweb.P2P.CutResponse do
  @moduledoc """
  `CutResponse` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type hashes :: map()
  @type weight :: String.t()
  @type height :: non_neg_integer()
  @type origin :: map() | nil

  @type t :: %__MODULE__{
          hashes: hashes(),
          height: height(),
          weight: weight(),
          origin: origin()
        }

  defstruct [:hashes, :height, :weight, :id, :instance, :origin]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
