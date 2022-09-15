defmodule Kadena.Types.PactInt do
  @moduledoc """
  `PactInt` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{value: String.t()}

  defstruct [:value]

  @impl true
  def new(value) when is_binary(value), do: %__MODULE__{value: value}
  def new(_value), do: {:error, :invalid_int}
end
