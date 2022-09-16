defmodule Kadena.Types.PactInt do
  @moduledoc """
  `PactInt` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{value: integer(), raw_value: String.t()}

  defstruct [:value, :raw_value]

  @impl true
  def new(value) when is_integer(value),
    do: %__MODULE__{value: value, raw_value: to_string(value)}

  def new(_value), do: {:error, :invalid_int}
end
