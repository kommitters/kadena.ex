defmodule Kadena.Types.UnsignedSignatureWithHash do
  @moduledoc """
  `UnsignedSignatureWithHash` struct definition.
  """
  alias Kadena.Types.Signature

  @behaviour Kadena.Types.Spec

  @type sig :: Signature.t()
  @type public_key :: String.t() | nil

  @type t :: %__MODULE__{
          hash: String.t(),
          sig: sig(),
          pub_key: public_key()
        }

  defstruct [:hash, :sig, :pub_key]

  @impl true
  def new(args) do
    hash = Keyword.get(args, :hash)
    sig = Keyword.get(args, :sig)
    pub_key = Keyword.get(args, :pub_key)

    with hash when is_binary(hash) <- hash,
         pub_key when is_binary(pub_key) or is_nil(pub_key) <- pub_key,
         %Signature{} <- sig do
      %__MODULE__{hash: hash, sig: sig, pub_key: pub_key}
    else
      _error -> {:error, :invalid_unsigned_signature}
    end
  end
end
