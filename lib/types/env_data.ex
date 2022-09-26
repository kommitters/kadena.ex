defmodule Kadena.Types.EnvData do
  @moduledoc """
  `EnvData` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{data: map()}

  defstruct [:data]

  @impl true
  def new(data) when is_map(data), do: %__MODULE__{data: data}
  def new(_data), do: {:error, [env_data: :invalid]}
end
