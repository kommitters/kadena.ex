defmodule Kadena.Chainweb.Pact.CommandResult do
  @moduledoc """
  `CommandResult` struct definition.
  """

  @type req_key :: String.t()
  @type tx_id :: number() | nil
  @type result :: map()
  @type gas :: number()
  @type logs :: String.t() | nil
  @type continuation :: map() | nil
  @type meta_data :: map() | nil
  @type events :: list(map()) | nil

  @type t :: %__MODULE__{
          req_key: req_key(),
          tx_id: tx_id(),
          result: result(),
          gas: gas(),
          logs: logs(),
          continuation: continuation(),
          meta_data: meta_data(),
          events: events()
        }

  defstruct [:req_key, :tx_id, :result, :gas, :logs, :continuation, :meta_data, :events]

  def new(attrs), do: struct(%__MODULE__{}, attrs)
end
