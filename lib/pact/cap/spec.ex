defmodule Kadena.Pact.Cap.Spec do
  @moduledoc """
  Specification for `Cryptography.Pact`.
  """
  alias Kadena.Types.Cap

  @type cap :: Cap.t()
  @type name :: String.t()
  @type values :: list()

  @callback create_cap(name(), values()) :: {:ok, cap()}
end
