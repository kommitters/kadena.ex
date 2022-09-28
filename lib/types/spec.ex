defmodule Kadena.Types.Spec do
  @moduledoc """
  Defines base types constructions.
  """

  @type reason :: atom() | Keyword.t()
  @type error :: {:error, reason()}

  @callback new(any()) :: struct() | {:error, error()}
end
