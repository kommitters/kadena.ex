defmodule Kadena.Chainweb.Pact.SPVRequestBody do
  @moduledoc """
  `SPVRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Types.{Base64Url, ChainID}

  @behaviour Kadena.Chainweb.Pact.Type

  @type request_key :: Base64Url.t()
  @type target_chain_id :: ChainID.t()
  @type value :: request_key() | target_chain_id()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{request_key: request_key(), target_chain_id: target_chain_id()}

  defstruct [:request_key, :target_chain_id]

  @impl true
  def new(args) when is_list(args) do
    request_key = Keyword.get(args, :request_key)
    target_chain_id = Keyword.get(args, :target_chain_id)

    with {:ok, request_key} <- validate_request_key(request_key),
         {:ok, target_chain_id} <- validate_target_chain_id(target_chain_id) do
      %__MODULE__{request_key: request_key, target_chain_id: target_chain_id}
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

  @spec validate_target_chain_id(target_chain_id :: target_chain_id()) :: validation()
  defp validate_target_chain_id(%ChainID{} = target_chain_id), do: {:ok, target_chain_id}

  defp validate_target_chain_id(target_chain_id) do
    case ChainID.new(target_chain_id) do
      %ChainID{} = target_chain_id -> {:ok, target_chain_id}
      {:error, reasons} -> {:error, [target_chain_id: :invalid] ++ reasons}
    end
  end

  defimpl JSONPayload do
    alias Kadena.Chainweb.Pact.SPVRequestBody
    alias Kadena.Utils.MapCase

    @type request_key :: Base64Url.t()
    @type target_chain_id :: ChainID.t()
    @type value :: String.t()

    @impl true
    def parse(%SPVRequestBody{request_key: request_key, target_chain_id: chain_id}) do
      request_key = extract_key(request_key)
      chain_id = extract_chain_id(chain_id)

      %{request_key: request_key, target_chain_id: chain_id}
      |> MapCase.to_camel!()
      |> Jason.encode!()
    end

    @spec extract_key(request_key()) :: value()
    defp extract_key(%Base64Url{url: url}), do: url

    @spec extract_chain_id(target_chain_id()) :: value()
    defp extract_chain_id(%ChainID{id: id}), do: id
  end
end
