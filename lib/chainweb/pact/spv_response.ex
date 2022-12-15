defmodule Kadena.Chainweb.Pact.SPVResponse do
  @moduledoc """
  `SPVResponse` struct definition.
  """

  @type response :: String.t()

  @type t :: %__MODULE__{response: response()}

  defstruct [:response]

  def new(response) when is_binary(response), do: struct(%__MODULE__{}, response: response)
end
