defmodule Kadena.Types.ChainID do
  @moduledoc """
  `ChainID` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type id :: String.t()

  @type t :: %__MODULE__{id: id()}

  defstruct [:id]

  @impl true
  def new(id) when is_binary(id), do: %__MODULE__{id: id}
  def new(_id), do: {:error, [id: :invalid]}
end
