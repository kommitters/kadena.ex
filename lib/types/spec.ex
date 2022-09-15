defmodule Kadena.Types.Spec do
  @moduledoc """
  Defines base types constructions
  """

  @type error :: {:error, atom()}

  @callback new(any()) :: struct() | error()
end
