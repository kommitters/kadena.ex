defmodule Kadena.Chainweb.Pact.Resources.ListenResponse do
  @moduledoc """
  `ListenResponse` struct definition.
  """

  alias Kadena.Types.{
    Base64Url,
    PactExec
  }

  alias Kadena.Chainweb.Pact.Resources.{
    CommandResult,
    PactEventsList,
    PactResult,
    ResponseMetaData
  }

  @behaviour Kadena.Chainweb.Resource

  @type req_key :: Base64Url.t()
  @type tx_id :: number() | nil
  @type result :: PactResult.t()
  @type gas :: number()
  @type logs :: String.t() | nil
  @type continuation :: PactExec.t()
  @type meta_data :: ResponseMetaData.t() | nil
  @type events :: PactEventsList.t() | nil

  @type command_result :: CommandResult.t()
  @type validation :: t() | {:error, Keyword.t()}

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

  @impl true
  def new(attrs) do
    attrs
    |> CommandResult.new()
    |> build_listen_response()
  end

  @spec build_listen_response(command_result :: command_result()) :: validation()
  defp build_listen_response(%CommandResult{} = command_result) do
    attrs = Map.from_struct(command_result)
    struct(%__MODULE__{}, attrs)
  end
end
