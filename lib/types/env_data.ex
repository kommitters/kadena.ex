defmodule Kadena.Types.EnvData do
  @moduledoc """
  `EnvData` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type data :: map()

  @type t :: %__MODULE__{data: data()}

  defstruct [:data]

  @impl true
  def new(data) when is_map(data), do: %__MODULE__{data: data}
  def new(_data), do: {:error, [data: :invalid]}
end
