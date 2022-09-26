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
    with {:ok, literal} <- set_type(literal) do
      %__MODULE__{value: literal}
    end
  end

  @spec set_type(literal :: literal() | list()) :: validation()
  defp set_type(int) when is_number(int) do
    case PactInt.new(int) do
      %PactInt{} = pact_int -> {:ok, pact_int}
      _error -> {:ok, int}
    end
  end

  defp set_type(boolean) when is_boolean(boolean), do: {:ok, boolean}

  defp set_type([_head | _tail] = list) do
    with %PactValuesList{} = pact_list <- PactValuesList.new(list) do
      {:ok, pact_list}
    end
  end

  defp set_type(value) when is_binary(value) do
    case PactDecimal.new(value) do
      %PactDecimal{} = decimal -> {:ok, decimal}
      _error -> {:ok, value}
    end
  end

  defp set_type(_other_type), do: {:error, [value: :invalid_type]}
end
