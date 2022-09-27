defmodule Kadena.Types.Proof do
  @moduledoc """
  `Proof` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type url :: String.t() | nil
  @type t :: %__MODULE__{url: url()}

  defstruct [:url]

  @impl true
  def new(nil), do: %__MODULE__{url: nil}
  def new(url) when is_binary(url), do: %__MODULE__{url: url}
  def new(_proof), do: {:error, [proof: :invalid]}
end
