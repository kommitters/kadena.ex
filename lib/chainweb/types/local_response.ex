defmodule Kadena.Chainweb.Types.LocalResponse do
  @moduledoc """
  `LocalResponse` struct definition.
  """

  alias Kadena.Types.{
    Base64Url,
    ChainwebResponseMetaData,
    OptionalPactEventsList,
    PactExec,
    PactResult
  }

  alias Kadena.Chainweb.Types.CommandResult

  @behaviour Kadena.Types.Spec

  @type req_key :: Base64Url.t()
  @type tx_id :: number() | nil
  @type result :: PactResult.t()
  @type gas :: number()
  @type logs :: String.t() | nil
  @type continuation :: PactExec.t()
  @type meta_data :: ChainwebResponseMetaData.t() | nil
  @type events :: OptionalPactEventsList.t()
  @type command_result :: CommandResult.t()
  @type errors :: {:error, Keyword.t()}

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
  def new(args) do
    args
    |> CommandResult.new()
    |> build_local_request_body()
  end

  @spec build_local_request_body(command_result :: command_result() | errors()) :: t() | errors()
  defp build_local_request_body(%CommandResult{} = command_result) do
    attrs = Map.from_struct(command_result)
    struct(%__MODULE__{}, attrs)
  end

  defp build_local_request_body({:error, reason}), do: {:error, reason}
end
