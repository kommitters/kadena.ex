defmodule Kadena.Types.Nonce do
  @moduledoc """
  `Nonce` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type value :: String.t()

  @type t :: %__MODULE__{value: value()}

  defstruct [:value]

  @impl true
  def new(str) when is_binary(str), do: %__MODULE__{value: str}
  def new(_value), do: {:error, [value: :invalid]}
end
