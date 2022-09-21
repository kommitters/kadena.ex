defmodule Kadena.Types.NetworkId do
  @moduledoc """
  `NetworkId` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @networks_id [:mainnet01, :testnet04, :development, nil]

  @type id :: :mainnet01 | :testnet04 | :development | nil
  @type t :: %__MODULE__{id: id()}

  defstruct [:id]

  @impl true
  def new(id) when id in @networks_id, do: %__MODULE__{id: id}
  def new(_value), do: {:error, :invalid_network_id}
end
