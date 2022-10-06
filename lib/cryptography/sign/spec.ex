defmodule Kadena.Cryptography.Sign.Spec do
  @moduledoc """
  Specification for `Cryptography.Sign` contracts.
  """
  alias Kadena.Types.{KeyPair, SignCommand}

  @type keypair :: KeyPair.t()
  @type hash :: String.t()
  @type msg :: String.t()
  @type sig :: String.t()
  @type pub_key :: String.t()
  @type sign_cmd :: SignCommand.t()

  @callback sign(msg(), keypair()) :: {:ok, sign_cmd()}
  @callback sign_hash(hash(), keypair()) :: {:ok, sign_cmd()}
  @callback verify_sign(hash(), sig(), pub_key()) :: boolean()
end
