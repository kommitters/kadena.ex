defmodule Kadena.Types.Nonce do
  @moduledoc """
  `Nonce` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{value: String.t()}

  defstruct [:value]

  @impl true
  def new(str) when is_binary(str), do: %__MODULE__{value: str}
  def new(_value), do: {:error, [nonce: :invalid]}
end
