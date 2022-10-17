defmodule Kadena.Cryptography.Sign do
  @moduledoc """
  Documentation for `Cryptography.Sign` functions.
  """
  alias Kadena.Cryptography.Sign

  @behaviour Sign.Spec

  @impl true
  def sign(msg, keypair), do: impl().sign(msg, keypair)

  @impl true
  def sign_hash(hash, keypair), do: impl().sign_hash(hash, keypair)

  @impl true
  def verify_sign(msg, sig, pub_key), do: impl().verify_sign(msg, sig, pub_key)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :crypto_sign_impl, Sign.Default)
end
