defmodule Kadena.Types.PactDecimal do
  @moduledoc """
  `PactDecimal` struct definition.
  """

  alias Decimal

  @behaviour Kadena.Types.Spec

  @type decimal :: Decimal.t()
  @type value :: String.t()
  @type errors :: Keyword.t()
  @type validation :: {:ok, decimal()} | {:error, errors()}

  @type t :: %__MODULE__{value: value(), raw_value: decimal()}

  defstruct [:value, :raw_value]

  @lower_decimal_range -9_007_199_254_740_991
  @upper_decimal_range 9_007_199_254_740_991

  @impl true
  def new(value) do
    with {:ok, decimal} <- parse_decimal(value),
         {:ok, decimal} <- validate_decimal_range(decimal) do
      %__MODULE__{value: value, raw_value: decimal}
    end
  end

  @spec parse_decimal(value :: value()) :: validation()
  defp parse_decimal(value) when is_binary(value) do
    case Decimal.cast(value) do
      {:ok, decimal} -> {:ok, decimal}
      :error -> {:error, [value: :invalid]}
    end
  end

  @spec validate_decimal_range(decimal :: decimal()) :: validation()
  defp validate_decimal_range(decimal) do
    if Decimal.gt?(decimal, @upper_decimal_range) || Decimal.lt?(decimal, @lower_decimal_range),
      do: {:ok, decimal},
      else: {:error, [value: :not_in_range]}
  end
end
