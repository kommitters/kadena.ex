defmodule Kadena.Chainweb.P2P.BlockPayloadResponse do
  @moduledoc """
  `BlockPayloadResponse` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type miner_data :: String.t()
  @type transactions_hash :: String.t()
  @type outputs_hash :: String.t()
  @type payload_hash :: String.t()
  @type transactions :: list(String.t())

  @type t :: %__MODULE__{
          transactions: transactions(),
          miner_data: miner_data(),
          transactions_hash: transactions_hash(),
          outputs_hash: outputs_hash(),
          payload_hash: payload_hash()
        }

  defstruct [:transactions, :miner_data, :transactions_hash, :outputs_hash, :payload_hash]

  @impl true
  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
