defmodule Kadena.Chainweb.Pact.Resources.PactEventModule do
  @moduledoc """
  `PactEventModule` struct definition.
  """

  alias Kadena.Chainweb.Mapping

  @behaviour Kadena.Chainweb.Resource

  @type name :: String.t()
  @type namespace :: String.t() | nil

  @type t :: %__MODULE__{name: name(), namespace: namespace()}

  defstruct [:name, :namespace]

  @impl true
  def new(attrs), do: Mapping.build(%__MODULE__{}, attrs)
end
