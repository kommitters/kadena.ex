defmodule Kadena.Types.NetworkID do
  @moduledoc """
  `NetworkID` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type id :: String.t()
  @type t :: %__MODULE__{id: id()}

  defstruct [:id]

  @impl true
  def new(nil), do: %__MODULE__{}
  def new(:mainnet01), do: %__MODULE__{id: "Mainnet01"}
  def new(:testnet04), do: %__MODULE__{id: "Testnet04"}
  def new(:development), do: %__MODULE__{id: "Development"}
  def new(_id), do: {:error, [id: :invalid]}
end
