defmodule Kadena.Types.PactInt do
  @moduledoc """
  `PactInt` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type value :: String.t()
  @type raw_value :: integer()
  @type errors :: Keyword.t()
  @type validation :: {:ok, raw_value()} | {:error, errors()}

  @type t :: %__MODULE__{value: value(), raw_value: raw_value()}

  defstruct [:value, :raw_value]

  @int_range -9_007_199_254_740_991..9_007_199_254_740_991

  @impl true
  def new(value) when is_integer(value) do
    case validate_int_range(value) do
      {:ok, int} -> %__MODULE__{value: to_string(int), raw_value: int}
      error -> error
    end
  end

  def new(_value), do: {:error, [value: :invalid]}

  @spec validate_int_range(raw_value :: raw_value()) :: validation()
  defp validate_int_range(raw_value) when raw_value not in @int_range, do: {:ok, raw_value}
  defp validate_int_range(_raw_value), do: {:error, [value: :not_in_range]}
end
