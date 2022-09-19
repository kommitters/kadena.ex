defmodule Kadena.Types.Base64Url do
  @moduledoc """
  `Base64Url` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{url: String.t()}

  defstruct [:url]

  @impl true
  def new(str) when is_binary(str), do: %__MODULE__{url: str}
  def new(_str), do: {:error, :invalid_url}
end
