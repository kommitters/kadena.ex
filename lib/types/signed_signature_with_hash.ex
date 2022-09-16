defmodule Kadena.Types.SignedSignatureWithHash do
  @moduledoc """
  `SignedSignatureWithHash` struct definition.
  """
  alias Kadena.Types.Signature

  @behaviour Kadena.Types.Spec

  @type sig :: Signature.t()

  @type t :: %__MODULE__{
          hash: String.t(),
          sig: sig(),
          pub_key: String.t()
        }

  defstruct [:hash, :sig, :pub_key]

  @impl true
  def new(args) do
    hash = Keyword.get(args, :hash)
    sig = Keyword.get(args, :sig)
    pub_key = Keyword.get(args, :pub_key)

    with hash when is_binary(hash) <- hash,
         pub_key when is_binary(pub_key) <- pub_key,
         %Signature{} <- sig do
      %__MODULE__{hash: hash, sig: sig, pub_key: pub_key}
    else
      _error -> {:error, :invalid_signature}
    end
  end
end
