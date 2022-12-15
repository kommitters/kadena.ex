defmodule Kadena.Chainweb.Pact.Resource do
  @moduledoc """
  Specifies contracts to build Chainweb Pact resources.
  """

  @type attrs :: map() | String.t()
  @type resource :: struct()

  @callback new(attrs()) :: resource()
end
