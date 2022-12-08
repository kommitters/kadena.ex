defmodule Kadena.Cryptography.Sign.Default do
  @moduledoc """
  Default implementation for `Cryptography.Sign` contracts.
  """
  import Kadena.Cryptography.Utils,
    only: [bin_to_hex: 1, blake2b_hash: 2, hex_to_bin: 1, url_encode64: 1, url_decode64: 1]

  alias Kadena.Cryptography.Sign
  alias Kadena.Types.{KeyPair, SignCommand}

  @behaviour Sign.Spec

  @type bin_hash :: binary()
  @type bin_key :: binary()
  @type sig :: String.t()

  @key_type :eddsa
  @digest_type :sha256
  @edwards_curve_ed :ed25519

  @impl true
  def sign(msg, nil) do
    with bin_msg <- blake2b_hash(msg, byte_size: 32),
         hash <- url_encode64(bin_msg) do
      {:ok, SignCommand.new(hash: hash)}
    end
  end

  def sign(msg, %KeyPair{pub_key: pub_key, secret_key: secret_key}) do
    with bin_msg <- blake2b_hash(msg, byte_size: 32),
         hash <- url_encode64(bin_msg),
         bin_secret_key <- hex_to_bin(secret_key),
         sig <- build_sig(bin_msg, bin_secret_key) do
      {:ok, SignCommand.new(hash: hash, sig: sig, pub_key: pub_key)}
    end
  end

  @impl true
  def sign_hash(hash, %KeyPair{pub_key: pub_key, secret_key: secret_key}) do
    with bin_hash <- url_decode64(hash),
         bin_secret_key <- hex_to_bin(secret_key),
         sig <- build_sig(bin_hash, bin_secret_key) do
      {:ok, SignCommand.new(hash: hash, sig: sig, pub_key: pub_key)}
    end
  end

  @impl true
  def verify_sign(hash, sig, pub_key) do
    with bin_pub_key <- hex_to_bin(pub_key),
         bin_hash <- url_decode64(hash),
         bin_sig <- hex_to_bin(sig) do
      :crypto.verify(@key_type, @digest_type, {:digest, bin_hash}, bin_sig, [
        bin_pub_key,
        @edwards_curve_ed
      ])
    end
  end

  @spec build_sig(bin_hash :: bin_hash(), bin_secret_key :: bin_key()) :: sig()
  defp build_sig(bin_hash, bin_secret_key) do
    @key_type
    |> :crypto.sign(@digest_type, {:digest, bin_hash}, [bin_secret_key, @edwards_curve_ed])
    |> bin_to_hex()
  end
end
