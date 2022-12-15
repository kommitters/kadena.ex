defmodule Kadena.Chainweb.Pact.SendResponse do
  @moduledoc """
  `SendResponse` struct definition.
  """

  @type request_keys :: list(String.t())

  @type t :: %__MODULE__{request_keys: request_keys()}

  defstruct request_keys: []

  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
