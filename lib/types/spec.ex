defmodule Kadena.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """

  @type reasons :: Keyword.t()
  @type error :: {:error, reasons()}

  @callback new(any()) :: struct() | error()
end
