defmodule Kadena.Types.PactLiteral do
  @moduledoc """
  `PactLiteral` struct definition.
  """
  alias Kadena.Types.{PactDecimal, PactInt}

  @behaviour Kadena.Types.Spec

  @type literal :: PactInt.t() | PactDecimal.t() | String.t() | number() | boolean()

  @type t :: %__MODULE__{literal: literal()}

  defstruct [:literal]

  @impl true
  def new(%PactInt{} = pact_int), do: %__MODULE__{literal: pact_int}
  def new(%PactDecimal{} = pact_decimal), do: %__MODULE__{literal: pact_decimal}
  def new(str) when is_binary(str), do: %__MODULE__{literal: str}
  def new(number) when is_number(number), do: %__MODULE__{literal: number}
  def new(bool) when is_boolean(bool), do: %__MODULE__{literal: bool}
  def new(_literal), do: {:error, :invalid_literal}
end
