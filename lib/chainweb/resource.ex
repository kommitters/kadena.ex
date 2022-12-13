defmodule Kadena.Chainweb.Resource do
  @moduledoc """
  Specifies contracts to build Chainweb resources.
  """

  @type attrs :: map()
  @type resource :: struct()

  @callback new(attrs()) :: resource()
end
