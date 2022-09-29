defmodule Kadena.Types.Proof do
  @moduledoc """
  `Proof` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type value :: String.t()
  @type t :: %__MODULE__{value: value()}

  defstruct [:value]

  @impl true
  def new(value) when is_binary(value), do: %__MODULE__{value: value}
  def new(_proof), do: {:error, [value: :invalid]}
end
