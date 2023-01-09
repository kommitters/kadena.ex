defmodule Kadena.Chainweb.Pact.SPVResponse do
  @moduledoc """
  `SPVResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type proof :: String.t()

  @type t :: %__MODULE__{proof: proof()}

  defstruct [:proof]

  @impl true
  def new(proof) when is_binary(proof), do: struct(%__MODULE__{}, proof: proof)
end
