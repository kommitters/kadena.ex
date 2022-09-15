defmodule Kadena.Types.PactDecimal do
  @moduledoc """
  `PactDecimal` struct definition.
  """

  alias Decimal

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{
          value: Decimal.t(),
          raw_value: String.t()
        }

  defstruct [:value, :raw_value]

  @impl true
  def new(str) when is_binary(str), do: %__MODULE__{value: Decimal.new(str), raw_value: str}
  def new(_str), do: {:error, :invalid_decimal}
end
