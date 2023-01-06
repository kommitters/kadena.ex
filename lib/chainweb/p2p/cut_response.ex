defmodule Kadena.Chainweb.P2P.CutResponse do
  @moduledoc """
  `CutResponse` struct definition.
  """

  @type hashes :: map()
  @type weight :: String.t()
  @type height :: integer()
  @type origin :: map() | nil
  @type attrs :: map()

  @type t :: %__MODULE__{
          hashes: hashes(),
          height: height(),
          weight: weight(),
          origin: origin()
        }

  defstruct [:hashes, :height, :weight, :id, :instance, :origin]

  @spec new(attrs: attrs()) :: t()
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
