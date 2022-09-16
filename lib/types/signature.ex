defmodule Kadena.Types.Signature do
  @moduledoc """
  `Signature` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type sig :: String.t() | nil

  @type t :: %__MODULE__{sig: sig()}

  defstruct [:sig]

  @impl true
  def new(sig \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(sig) when is_binary(sig), do: %__MODULE__{sig: sig}
  def new(_sig), do: {:error, :invalid_signature}
end
