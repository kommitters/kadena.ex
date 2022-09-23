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
  def new(decimal) when is_float(decimal) do
    case validate_float(decimal) do
      {:ok, value} ->
        %__MODULE__{value: Decimal.new(value), raw_value: value}

      error ->
        error
    end
  end

  def new(_str), do: {:error, [value: :invalid_decimal]}

  defp validate_float(value) when -9_007_199_254_740_991 > value or value > 9_007_199_254_740_991,
    do: {:ok, to_string(value)}

  defp validate_float(_value), do: {:error, [value: :invalid_range]}
end
