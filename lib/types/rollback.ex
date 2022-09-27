defmodule Kadena.Types.Rollback do
  @moduledoc """
  `Rollback` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{value: boolean()}

  defstruct [:value]

  @impl true
  def new(bool) when is_boolean(bool), do: %__MODULE__{value: bool}
  def new(_value), do: {:error, [rollback: :invalid]}
end
