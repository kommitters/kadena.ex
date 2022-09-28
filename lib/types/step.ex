defmodule Kadena.Types.Step do
  @moduledoc """
  `Step` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{number: integer()}

  defstruct [:number]

  @impl true
  def new(number) when is_integer(number), do: %__MODULE__{number: number}
  def new(_number), do: {:error, [number: :invalid]}
end
