defmodule Kadena.Types.PactValue do
  @moduledoc """
  `PactValue` structure definition.
  """

  import Kadena.Types.PactLiteral

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{
          value: PactLiteral.t() | list(PactLiteral.t())
        }

  defstruct [:value]

  @impl true
  def new(value) when is_literal(value), do: %__MODULE__{value: value}

  def new(value) when is_list(value) and length(value) > 0 do
    value_length = length(value)

    value
    |> Enum.filter(fn val -> is_literal(val) end)
    |> length()
    |> (&if(value_length == &1, do: %__MODULE__{value: value}, else: {:error, :invalid_value})).()
  end

  def new(_value), do: {:error, :invalid_value}
end
