defmodule Kadena.Cryptography.KeyPair.Spec do
  @moduledoc """
  Specification for `Cryptography.KeyPair` contracts.
  """
  alias Kadena.Types.KeyPair

  @type keypair :: KeyPair.t()
  @type secret_key :: String.t()

  @callback generate :: {:ok, keypair()}
  @callback from_secret_key(secret_key()) :: {:ok, keypair()}
end
