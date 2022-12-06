defmodule Kadena.Chainweb.Types.CommandResult do
  @moduledoc """
  `CommandResult` struct definition.
  """

  alias Kadena.Types.{
    Base64Url,
    ChainwebResponseMetaData,
    OptionalPactEventsList,
    PactEventsList,
    PactExec,
    PactResult
  }

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type req_key :: Base64Url.t()
  @type tx_id :: number() | nil
  @type result :: PactResult.t()
  @type gas :: number()
  @type logs :: String.t() | nil
  @type continuation :: PactExec.t()
  @type meta_data :: ChainwebResponseMetaData.t() | nil
  @type events :: OptionalPactEventsList.t()
  @type events_arg :: PactEventsList.t() | list() | nil
  @type value ::
          str()
          | req_key()
          | tx_id()
          | result()
          | gas()
          | logs()
          | continuation()
          | meta_data()
          | events()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

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
         {:ok, tx_id} <- validate_number(:tx_id, tx_id),
         {:ok, result} <- validate_result(result),
         {:ok, gas} <- validate_number(:gas, gas),
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

  @spec validate_req_key(req_key :: str()) :: validation()
  defp validate_req_key(req_key) do
    case Base64Url.new(req_key) do
      %Base64Url{} = req_key -> {:ok, req_key}
      _error -> {:error, [req_key: :invalid]}
    end
  end

  @spec validate_number(field :: atom(), value :: number()) :: validation()
  defp validate_number(:tx_id, nil), do: {:ok, nil}
  defp validate_number(_field, value) when is_number(value), do: {:ok, value}
  defp validate_number(field, _tx_id), do: {:error, [{field, :invalid}]}

  @spec validate_result(result :: result()) :: validation()
  defp validate_result(%PactResult{} = result), do: {:ok, result}

  defp validate_result(result) when is_list(result) do
    case PactResult.new(result) do
      %PactResult{} = result -> {:ok, result}
      {:error, reason} -> {:error, [result: :invalid] ++ reason}
    end
  end

  defp validate_result(_result), do: {:error, [result: :invalid]}

  @spec validate_logs(logs :: logs()) :: validation()
  defp validate_logs(nil), do: {:ok, nil}
  defp validate_logs(logs) when is_binary(logs), do: {:ok, logs}
  defp validate_logs(_logs), do: {:error, [logs: :invalid]}

  @spec validate_continuation(continuation :: continuation()) :: validation()
  defp validate_continuation(%PactExec{} = continuation), do: {:ok, continuation}

  defp validate_continuation(continuation) when is_list(continuation) do
    case PactExec.new(continuation) do
      %PactExec{} = continuation -> {:ok, continuation}
      {:error, reason} -> {:error, [continuation: :invalid] ++ reason}
    end
  end

  defp validate_continuation(_continuation), do: {:error, [continuation: :invalid]}

  @spec validate_meta_data(meta_data :: meta_data()) :: validation()
  defp validate_meta_data(nil), do: {:ok, nil}
  defp validate_meta_data(%ChainwebResponseMetaData{} = meta_data), do: {:ok, meta_data}

  defp validate_meta_data(meta_data) when is_list(meta_data) do
    case ChainwebResponseMetaData.new(meta_data) do
      %ChainwebResponseMetaData{} = meta_data -> {:ok, meta_data}
      {:error, reason} -> {:error, [meta_data: :invalid] ++ reason}
    end
  end

  defp validate_meta_data(_result), do: {:error, [meta_data: :invalid]}

  @spec validate_events(events :: events_arg()) :: validation()
  defp validate_events(nil), do: {:ok, OptionalPactEventsList.new()}
  defp validate_events(%PactEventsList{} = events), do: {:ok, OptionalPactEventsList.new(events)}

  defp validate_events(events) when is_list(events) do
    with %PactEventsList{} = pact_events <- PactEventsList.new(events),
         %OptionalPactEventsList{} = optional_events <- OptionalPactEventsList.new(pact_events) do
      {:ok, optional_events}
    else
      {:error, reason} -> {:error, [events: :invalid] ++ reason}
    end
  end

  defp validate_events(_events), do: {:error, [events: :invalid]}
end
