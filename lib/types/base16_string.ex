defmodule Kadena.Types.Base16String do
  @moduledoc """
  `Base16String` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{value: String.t()}

  defstruct [:value]

  @impl true
  def new(str) when is_binary(str), do: %__MODULE__{value: str}
  def new(_str), do: {:error, [value: :invalid]}
end
