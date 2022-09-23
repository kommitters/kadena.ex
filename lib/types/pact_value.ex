defmodule Kadena.Types.PactValue do
  @moduledoc """
  `PactValue` structure definition.
  """
  alias Kadena.Types.{PactDecimal, PactInt, PactValuesList}

  @behaviour Kadena.Types.Spec

  @type literal :: PactInt.t() | PactDecimal.t() | String.t() | number() | boolean()
  @type pact_value :: literal() | PactValuesList.t()
  @type validation :: {:ok, literal()} | {:error, list()}

  @type t :: %__MODULE__{value: pact_value()}

  defstruct [:value]

  @impl true
  def new(literal) do
    case set_type(literal) do
      {:ok, literal} -> %__MODULE__{value: literal}
      {:error, error} -> {:error, error}
    end
  end

  @spec set_type(literal :: literal() | list()) :: validation()
  defp set_type(decimal) when is_float(decimal) do
    case PactDecimal.new(decimal) do
      %PactDecimal{} = pact_decimal -> {:ok, pact_decimal}
      {:error, [value: :invalid_range]} -> {:ok, decimal}
      error -> error
    end
  end

  defp set_type(int) when is_integer(int) do
    case PactInt.new(int) do
      %PactInt{} = pact_int -> {:ok, pact_int}
      {:error, [value: :invalid_range]} -> {:ok, int}
      {:error, error} -> {:error, error}
    end
  end

  defp set_type(boolean) when is_boolean(boolean), do: {:ok, boolean}

  defp set_type(number) when is_number(number), do: {:ok, number}

  defp set_type([_head | _tail] = list) do
    case PactValuesList.new(list) do
      %PactValuesList{} = pact_list -> {:ok, pact_list}
      {:error, error} -> {:error, error}
    end
  end

  defp set_type(str) when is_binary(str), do: {:ok, str}

  defp set_type(_other_type), do: {:error, [value: :invalid_type]}
end
