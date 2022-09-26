defmodule Kadena.Types.PactDecimal do
  @moduledoc """
  `PactDecimal` struct definition.
  """

  alias Decimal

  @behaviour Kadena.Types.Spec

  @type value :: Decimal.t()
  @type t :: %__MODULE__{value: value(), raw_value: String.t()}

  defstruct [:value, :raw_value]

  @impl true
  def new(str) when is_binary(str) do
    with {:ok, value} <- validate_float(str) do
      %__MODULE__{value: Decimal.new(value), raw_value: value}
    end
  end

  def new(_str), do: {:error, [value: :invalid_decimal]}

  defp validate_float(value) do
    with {_val, ""} <- Float.parse(value),
         decimal <- Decimal.new(value),
         true <-
           Decimal.gt?(decimal, 9_007_199_254_740_991) or
             Decimal.lt?(decimal, -9_007_199_254_740_991) do
      {:ok, value}
    else
      _error -> {:error, [value: :invalid_range]}
    end
  end
end
