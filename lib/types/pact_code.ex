defmodule Kadena.Types.PactCode do
  @moduledoc """
  `PactCode` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type code :: String.t()

  @type t :: %__MODULE__{code: code()}

  defstruct [:code]

  @impl true
  def new(code) when is_binary(code), do: %__MODULE__{code: code}
  def new(_code), do: {:error, [code: :invalid]}
end
