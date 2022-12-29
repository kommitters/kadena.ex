defmodule Kadena.Types.PactValue do
  @moduledoc """
  `PactValue` structure definition.
  """
  alias Kadena.Types.{PactDecimal, PactInt, PactValue}

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type raw_decimal :: float() | str()
  @type decimal :: Decimal.t()
  @type error_list :: Keyword.t()
  @type literal ::
          integer()
          | decimal()
          | boolean()
          | String.t()
          | PactInt.t()
          | PactDecimal.t()
          | list(PactValue.t())
  @type validation :: {:ok, literal()} | {:error, error_list()}

  @type t :: %__MODULE__{literal: literal()}

  defstruct [:literal]

  @lower_decimal_range -9_007_199_254_740_991
  @upper_decimal_range 9_007_199_254_740_991
  @number_range @lower_decimal_range..@upper_decimal_range

  @impl true
  def new(literal) when is_boolean(literal), do: %__MODULE__{literal: literal}

  def new(literal) when is_integer(literal) and literal in @number_range,
    do: %__MODULE__{literal: literal}

  def new(literal) when is_integer(literal) and literal not in @number_range,
    do: %__MODULE__{literal: PactInt.new(literal)}

  def new(literal) when is_float(literal) do
    with {:ok, decimal} <- cast_to_decimal(literal),
         {:ok, decimal} <- validate_decimal_range(decimal) do
      %__MODULE__{literal: decimal}
    end
  end

  def new(literal) when is_binary(literal) do
    if is_decimal_expresion?(literal),
      do: build_pact_decimal(literal),
      else: %__MODULE__{literal: literal}
  end

  def new([%PactValue{} | _rest] = pact_values), do: %__MODULE__{literal: pact_values}
  def new([]), do: %__MODULE__{literal: []}
  def new(_literal), do: {:error, [literal: :invalid]}

  @spec build_pact_decimal(str :: str()) :: t() | {:error, error_list()}
  defp build_pact_decimal(str) do
    case PactDecimal.new(str) do
      %PactDecimal{} = pact_decimal -> %__MODULE__{literal: pact_decimal}
      {:error, [{_field, reason}]} -> {:error, [literal: reason]}
    end
  end

  @spec cast_to_decimal(float :: float()) :: validation()
  defp cast_to_decimal(float) do
    float
    |> to_string()
    |> Decimal.cast()
  end

  @spec validate_decimal_range(decimal :: decimal()) :: validation()
  defp validate_decimal_range(decimal) do
    if Decimal.gt?(@upper_decimal_range, decimal) && Decimal.lt?(@lower_decimal_range, decimal),
      do: {:ok, decimal},
      else: {:error, [literal: :not_in_range]}
  end

  @spec is_decimal_expresion?(expr :: str()) :: boolean()
  defp is_decimal_expresion?(expr), do: Regex.match?(~r/^[-]?([0-9]*[.])?[0-9]+$/, expr)
end
