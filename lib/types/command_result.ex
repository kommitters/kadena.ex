defmodule Kadena.Types.CommandResult do
  @moduledoc """
  `CommandResult` struct definition.
  """

  alias Kadena.Types.{
    Base64Url,
    ChainwebResponseMetaData,
    PactExec,
    PactEventsList,
    PactResultError,
    PactResultSuccess
  }

  @behaviour Kadena.Types.Spec

  @type req_key :: Base64Url.t()
  @type tx_id :: integer()
  @type result :: PactResultSuccess | PactResultError
  @type gas :: integer()
  @type logs :: String.t() | nil
  @type continuation :: PactExec.t() | nil
  @type meta_data :: ChainwebResponseMetaData.t() | nil
  @type events :: PactEventsList.t() | nil
  @type validation :: {:ok, any()} | {:error, atom()}

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
    req_key = Keyword.get(args, :req_key)
    tx_id = Keyword.get(args, :tx_id)
    result = Keyword.get(args, :result)
    gas = Keyword.get(args, :gas)
    logs = Keyword.get(args, :logs)
    continuation = Keyword.get(args, :continuation)
    meta_data = Keyword.get(args, :meta_data)
    events = Keyword.get(args, :events)

    with {:ok, req_key} <- validate_req_key(req_key),
         {:ok, tx_id} <- validate_tx_id(tx_id),
         {:ok, result} <- validate_result(result),
         {:ok, gas} <- validate_gas(gas),
         {:ok, logs} <- validate_logs(logs),
         {:ok, continuation} <- validate_continuation(continuation),
         {:ok, meta_data} <- validate_meta_data(meta_data),
         {:ok, events} <- validate_events(events) do
      %__MODULE__{
        req_key: req_key,
        tx_id: tx_id,
        result: result,
        gas: gas,
        logs: logs,
        continuation: continuation,
        meta_data: meta_data,
        events: events
      }
    end
  end

  @spec validate_req_key(req_key :: req_key()) :: validation()
  defp validate_req_key(%Base64Url{} = req_key), do: {:ok, req_key}
  defp validate_req_key(_req_key), do: {:error, :invalid_req_key}

  @spec validate_tx_id(tx_id :: tx_id()) :: validation()
  defp validate_tx_id(tx_id) when is_integer(tx_id), do: {:ok, tx_id}
  defp validate_tx_id(nil), do: {:ok, nil}
  defp validate_tx_id(_tx_id), do: {:error, :invalid_tx_id}

  @spec validate_result(result :: result()) :: validation()
  defp validate_result(%PactResultError{} = result), do: {:ok, result}
  defp validate_result(%PactResultSuccess{} = result), do: {:ok, result}
  defp validate_result(_result), do: {:error, :invalid_result}

  @spec validate_gas(gas :: gas()) :: validation()
  defp validate_gas(gas) when is_integer(gas), do: {:ok, gas}
  defp validate_gas(_gas), do: {:error, :invalid_gas}

  @spec validate_logs(logs :: logs()) :: validation()
  defp validate_logs(logs) when is_binary(logs), do: {:ok, logs}
  defp validate_logs(nil), do: {:ok, nil}
  defp validate_logs(_logs), do: {:error, :invalid_logs}

  @spec validate_continuation(continuation :: continuation()) :: validation()
  defp validate_continuation(%PactExec{} = continuation), do: {:ok, continuation}
  defp validate_continuation(nil), do: {:ok, nil}
  defp validate_continuation(_continuation), do: {:error, :invalid_continuation}

  @spec validate_meta_data(meta_data :: meta_data()) :: validation()
  defp validate_meta_data(%ChainwebResponseMetaData{} = meta_data), do: {:ok, meta_data}
  defp validate_meta_data(nil), do: {:ok, nil}
  defp validate_meta_data(_meta_data), do: {:error, :invalid_meta_data}

  @spec validate_events(events :: events()) :: validation()
  defp validate_events(%PactEventsList{} = events), do: {:ok, events}
  defp validate_events(nil), do: {:ok, nil}
  defp validate_events(_events), do: {:error, :invalid_events}
end
