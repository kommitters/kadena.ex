defmodule Kadena.Types.NetworkID do
  @moduledoc """
  `NetworkID` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type id :: String.t()
  @type t :: %__MODULE__{id: id()}

  defstruct [:id]

  @impl true
  def new(id \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(:mainnet01), do: %__MODULE__{id: "mainnet01"}
  def new(:testnet04), do: %__MODULE__{id: "testnet04"}
  def new(:development), do: %__MODULE__{id: "development"}
  def new(_id), do: {:error, [id: :invalid]}
end
