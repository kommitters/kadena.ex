defmodule Kadena.Cryptography.KeyPair do
  @moduledoc """
  Implementation for `Cryptography.KeyPair` functions.
  """
  alias Kadena.Cryptography.KeyPair

  @behaviour KeyPair.Spec

  @impl true
  def generate, do: impl().generate()

  @impl true
  def from_secret_key(key), do: impl().from_secret_key(key)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :crypto_sign_impl, KeyPair.Default)
end
