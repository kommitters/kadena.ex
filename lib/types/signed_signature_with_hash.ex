defmodule Kadena.Types.SignedSignatureWithHash do
  @moduledoc """
  `SignedSignatureWithHash` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{
          hash: String.t(),
          sig: Signature.t(),
          pubKey: String.t()
        }

  defstruct [:hash, :sig, :pubKey]

  @impl true
  def new(hash: hash, sig: sig, pubKey: pub_key) when is_binary(hash) and is_binary(pub_key),
    do: %__MODULE__{hash: hash, sig: sig, pubKey: pub_key}

  def new(hash: hash, sig: _sig, pubKey: _pub_key) when not is_binary(hash),
    do: {:error, :invalid_hash}

  def new(hash: _hash, sig: _sig, pubKey: pub_key) when not is_binary(pub_key),
    do: {:error, :invalid_public_key}

  def new(_signature), do: {:error, :invalid_signature}
end
