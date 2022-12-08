defmodule Kadena.Types.SignatureWithHash do
  @moduledoc """
  `SignatureWithHash` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type hash :: String.t()
  @type sig :: String.t()
  @type pub_key :: String.t() | nil
  @type sig_type :: :unsigned_signature | :signed_signature
  @type validation :: {:ok, String.t()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{hash: hash(), sig: sig(), pub_key: pub_key(), type: sig_type()}

  defstruct [:hash, :sig, :pub_key, :type]

  @impl true
  def new(args) do
    hash = Keyword.get(args, :hash)
    sig = Keyword.get(args, :sig)
    pub_key = Keyword.get(args, :pub_key)

    with {:ok, hash} <- validate_hash(hash),
         {:ok, sig} <- validate_sig(sig) do
      sig_type = set_signature_type(pub_key)
      %__MODULE__{hash: hash, sig: sig, pub_key: pub_key, type: sig_type}
    end
  end

  @spec validate_hash(hash :: hash()) :: validation()
  defp validate_hash(hash) when is_binary(hash), do: {:ok, hash}
  defp validate_hash(_hash), do: {:error, [hash: :invalid]}

  @spec validate_sig(sig :: sig()) :: validation()
  defp validate_sig(sig) when is_binary(sig), do: {:ok, sig}
  defp validate_sig(nil), do: {:ok, nil}
  defp validate_sig(_sig), do: {:error, [sig: :invalid]}

  @spec set_signature_type(pub_key :: pub_key()) :: sig_type()
  defp set_signature_type(nil), do: :unsigned_signature
  defp set_signature_type(_pub_key), do: :signed_signature
end
