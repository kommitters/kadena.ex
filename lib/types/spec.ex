defmodule Kadena.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """

  @type reasons :: Keyword.t()
  @type error :: {:error, reasons()}

  @callback new() :: struct()
  @callback new(any()) :: struct() | error()

  @optional_callbacks new: 0
end
