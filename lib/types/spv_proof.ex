defmodule Kadena.Types.SPVProof do
  @moduledoc """
  `SPVProof` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type t :: %__MODULE__{value: str()}

  defstruct [:value]

  @impl true
  def new(value) when is_binary(value), do: %__MODULE__{value: value}
  def new(_value), do: {:error, [value: :invalid]}
end
