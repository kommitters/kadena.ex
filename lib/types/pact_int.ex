defmodule Kadena.Types.PactInt do
  @moduledoc """
  `PactInt` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type value :: integer()
  @type validation :: {:ok, any()} | {:error, list()}

  @type t :: %__MODULE__{value: value(), raw_value: String.t()}

  defstruct [:value, :raw_value]

  @impl true
  def new(value) when is_integer(value) do
    with {:ok, value} <- validate_range(value) do
      %__MODULE__{value: value, raw_value: to_string(value)}
    end
  end

  def new(_value), do: {:error, [value: :invalid_int]}

  @spec validate_range(value :: value()) :: validation()
  defp validate_range(value) when -9_007_199_254_740_991 > value or value > 9_007_199_254_740_991,
    do: {:ok, value}

  defp validate_range(_value), do: {:error, [value: :invalid_range]}
end
