defmodule Kadena.Types.PactCode do
  @moduledoc """
  `PactCode` struct definition
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{code: String.t()}

  defstruct [:code]

  @impl true
  def new(code) when is_binary(code), do: %__MODULE__{code: code}
  def new(_code), do: {:error, [pact_code: :invalid]}
end
