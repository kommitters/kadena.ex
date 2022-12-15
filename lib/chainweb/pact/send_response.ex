defmodule Kadena.Chainweb.Pact.SendResponse do
  @moduledoc """
  `SendResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Pact.Resource

  @type request_keys :: list(String.t())

  @type t :: %__MODULE__{request_keys: request_keys()}

  defstruct request_keys: []

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
