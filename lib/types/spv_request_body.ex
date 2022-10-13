defmodule Kadena.Types.SPVRequestBody do
  @moduledoc """
  `SPVRequestBody` struct definition.
  """

  alias Kadena.Types.{Base64Url, ChainID}

  @behaviour Kadena.Types.Spec

  @type request_key :: Base64Url.t()
  @type chain_id :: ChainID.t()
  @type value :: request_key() | chain_id()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{request_key: request_key(), chain_id: chain_id()}

  defstruct [:request_key, :chain_id]

  @impl true
  def new(args) when is_list(args) do
    request_key = Keyword.get(args, :request_key)
    chain_id = Keyword.get(args, :chain_id)

    with {:ok, request_key} <- validate_request_key(request_key),
         {:ok, chain_id} <- validate_chain_id(chain_id) do
      %__MODULE__{request_key: request_key, chain_id: chain_id}
    end
  end

  def new(_args), do: {:error, [spv_request_body: :not_a_list]}

  @spec validate_request_key(request_key :: request_key()) :: validation()
  defp validate_request_key(%Base64Url{} = request_key), do: {:ok, request_key}

  defp validate_request_key(request_key) do
    case Base64Url.new(request_key) do
      %Base64Url{} = request_key -> {:ok, request_key}
      {:error, _reasons} -> {:error, [request_key: :invalid]}
    end
  end

  @spec validate_chain_id(chain_id :: chain_id()) :: validation()
  defp validate_chain_id(%ChainID{} = chain_id), do: {:ok, chain_id}

  defp validate_chain_id(chain_id) do
    case ChainID.new(chain_id) do
      %ChainID{} = chain_id -> {:ok, chain_id}
      {:error, reasons} -> {:error, [chain_id: :invalid] ++ reasons}
    end
  end
end
