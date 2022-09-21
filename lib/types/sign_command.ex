defmodule Kadena.Types.SignCommand do
  @moduledoc """
  `SignCommand` struct definition.
  """

  alias Kadena.Types.{
    Signature,
    SignatureWithHash,
    SignedSignatureWithHash,
    UnsignedSignatureWithHash
  }

  @behaviour Kadena.Types.Spec

  @type command :: SignatureWithHash.t()

  @type t :: %__MODULE__{command: command()}

  defstruct [:command]

  @impl true
  def new(%SignatureWithHash{} = signature), do: %__MODULE__{command: signature}

  def new(args) when is_list(args) do
    hash = Keyword.get(args, :hash, nil)
    sig = Keyword.get(args, :sig, nil)
    pub_key = Keyword.get(args, :pub_key, nil)

    case validate(hash, sig, pub_key) do
      {:error, _error} -> {:error, :invalid_sign_command}
      signature -> %__MODULE__{command: SignatureWithHash.new(signature)}
    end
  end

  def new(_args), do: {:error, :invalid_sign_command}

  @spec validate(hash :: String.t(), sig :: Signature.t(), pub_key :: String.t()) ::
          SignedSignatureWithHash.t() | UnsignedSignatureWithHash.t() | {:error, atom()}
  defp validate(hash, sig, nil),
    do: UnsignedSignatureWithHash.new(hash: hash, sig: sig, pub_key: nil)

  defp validate(hash, sig, pub_key),
    do: SignedSignatureWithHash.new(hash: hash, sig: sig, pub_key: pub_key)
end
