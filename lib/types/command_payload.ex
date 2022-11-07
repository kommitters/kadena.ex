defmodule Kadena.Types.CommandPayload do
  @moduledoc """
  `CommandPayload` struct definition.
  """
  alias Kadena.Types.{MetaData, NetworkID, PactPayload, SignersList}

  @behaviour Kadena.Types.Spec

  @type network_id :: NetworkID.t() | nil
  @type payload :: PactPayload.t()
  @type signers :: SignersList.t()
  @type meta :: MetaData.t()
  @type nonce :: String.t()
  @type value :: network_id() | payload() | signers() | meta() | nonce()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}
  @type t :: %__MODULE__{
          network_id: network_id(),
          payload: payload(),
          signers: signers(),
          meta: meta(),
          nonce: nonce()
        }

  defstruct [:network_id, :payload, :signers, :meta, :nonce]

  @impl true
  def new(args) do
    network_id = Keyword.get(args, :network_id)
    payload = Keyword.get(args, :payload)
    signers = Keyword.get(args, :signers, [])
    meta = Keyword.get(args, :meta)
    nonce = Keyword.get(args, :nonce)

    with {:ok, network_id} <- validate_network_id(network_id),
         {:ok, payload} <- validate_payload(payload),
         {:ok, signers} <- validate_signers(signers),
         {:ok, meta} <- validate_meta(meta),
         {:ok, nonce} <- validate_nonce(nonce) do
      %__MODULE__{
        network_id: network_id,
        payload: payload,
        signers: signers,
        meta: meta,
        nonce: nonce
      }
    end
  end

  @spec validate_network_id(network_id :: network_id()) :: validation()
  defp validate_network_id(%NetworkID{} = network_id), do: {:ok, network_id}

  defp validate_network_id(network_id) do
    case NetworkID.new(network_id) do
      %NetworkID{} = network_id -> {:ok, network_id}
      _error -> {:error, [network_id: :invalid]}
    end
  end

  @spec validate_payload(payload :: payload()) :: validation()
  defp validate_payload(%PactPayload{} = payload), do: {:ok, payload}

  defp validate_payload(payload) do
    case PactPayload.new(payload) do
      %PactPayload{} = payload -> {:ok, payload}
      _error -> {:error, [payload: :invalid]}
    end
  end

  @spec validate_signers(signers :: signers()) :: validation()
  defp validate_signers(%SignersList{} = signers), do: {:ok, signers}

  defp validate_signers(signers) do
    case SignersList.new(signers) do
      %SignersList{} = signers -> {:ok, signers}
      _error -> {:error, [signers: :invalid]}
    end
  end

  @spec validate_meta(meta :: meta()) :: validation()
  defp validate_meta(%MetaData{} = meta), do: {:ok, meta}

  defp validate_meta(meta) do
    case MetaData.new(meta) do
      %MetaData{} = meta -> {:ok, meta}
      {:error, _reason} -> {:error, [meta: :invalid]}
    end
  end

  @spec validate_nonce(nonce :: nonce()) :: validation()
  defp validate_nonce(nonce) when is_binary(nonce), do: {:ok, nonce}
  defp validate_nonce(_nonce), do: {:error, [nonce: :not_a_string]}
end
