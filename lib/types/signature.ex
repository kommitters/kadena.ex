defmodule Kadena.Types.Signature do
  @moduledoc """
  `Signature` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type sig :: String.t()

  @type t :: %__MODULE__{sig: sig()}

  defstruct [:sig]

  @impl true
  def new(sig) when is_binary(sig), do: %__MODULE__{sig: sig}
  def new(_sig), do: {:error, [sig: :invalid]}
end
