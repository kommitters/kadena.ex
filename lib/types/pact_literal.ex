defmodule Kadena.Types.PactLiteral do
  @moduledoc """
  `PactLiteral` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{
          literal: String.t() | number() | PactInt.t() | PactDecimal.t() | boolean()
        }

  defstruct [:literal]

  defguard is_literal(literal)
           when is_binary(literal) or is_number(literal) or is_struct(literal, PactInt) or
                  is_struct(literal, PactDecimal) or is_boolean(literal)

  @impl true
  def new(literal) when is_literal(literal), do: %__MODULE__{literal: literal}
  def new(_literal), do: {:error, :invalid_literal}
end
