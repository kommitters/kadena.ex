defmodule Kadena.Types.ListenResponse do
  @moduledoc """
  `ListenResponse` struct definition.
  """

  alias Kadena.Types.CommandResult

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
  def new(args) when is_list(args) do
    args
    |> CommandResult.new()
    |> build_listen_response()
  end

  def new(_args), do: {:error, [listen_response: :not_a_list]}

  @spec build_listen_response(command_result :: command_result()) :: validation()
  defp build_listen_response(%CommandResult{} = command_result) do
    attrs = Map.from_struct(command_result)
    struct(%__MODULE__{}, attrs)
  end

  defp build_listen_response(error), do: error
end
