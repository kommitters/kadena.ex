defmodule Kadena.Cryptography.KeyPair.Default do
  @moduledoc """
  Default implementation for `Cryptography.KeyPair` contracts.
  """
  import Kadena.Cryptography.Utils, only: [bin_to_hex: 1, hex_to_bin: 1]

  alias Kadena.Types.KeyPair

  @behaviour Kadena.Cryptography.KeyPair.Spec

  @type bin_key :: binary()
  @type raw_keypair :: {bin_key(), bin_key()}
  @type keypair :: KeyPair.t()

  @key_type :eddsa
  @edwards_curve_ed :ed25519

  @impl true
  def generate do
    @key_type
    |> :crypto.generate_key(@edwards_curve_ed)
    |> build()
  end

  @impl true
  def from_secret_key(secret_key) do
    secret_key_bin = hex_to_bin(secret_key)

    @key_type
    |> :crypto.generate_key(@edwards_curve_ed, secret_key_bin)
    |> build()
  end

  @spec build(raw_keypair :: raw_keypair()) :: {:ok, keypair()}
  defp build({raw_pub_key, raw_secret_key}) do
    pub_key = bin_to_hex(raw_pub_key)
    secret_key = bin_to_hex(raw_secret_key)

    {:ok, KeyPair.new(pub_key: pub_key, secret_key: secret_key)}
  end
end
