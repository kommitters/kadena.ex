defmodule Kadena.Types.PollResponse do
  @moduledoc """
  `PollResponse` struct definition.
  """

  alias Kadena.Types.{Base64Url, CommandResult}

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type key :: Base64Url.t()
  @type response :: CommandResult.t()
  @type value :: key() | response()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{key: key(), response: response()}

  defstruct [:key, :response]

  @impl true
  def new(args) do
    key = Keyword.get(args, :key)
    response = Keyword.get(args, :response)

    with {:ok, key} <- validate_key(key),
         {:ok, response} <- validate_response(response) do
      %__MODULE__{key: key, response: response}
    end
  end

  @spec validate_key(key :: str()) :: validation()
  defp validate_key(key) do
    case Base64Url.new(key) do
      %Base64Url{} = key -> {:ok, key}
      {:error, _reason} -> {:error, [key: :invalid]}
    end
  end

  @spec validate_response(response :: response()) :: validation()
  defp validate_response(%CommandResult{} = response), do: {:ok, response}

  defp validate_response(response) when is_list(response) do
    case CommandResult.new(response) do
      %CommandResult{} = response -> {:ok, response}
      {:error, reason} -> {:error, [response: :invalid] ++ reason}
    end
  end

  defp validate_response(_response), do: {:error, [response: :invalid]}
end
