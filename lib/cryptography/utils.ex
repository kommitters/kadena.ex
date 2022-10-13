defmodule Kadena.Cryptography.Utils do
  @moduledoc """
  Documentation for `Cryptography.Utils` functions.
  """
  @type hash :: String.t()
  @type str :: String.t()
  @type key :: String.t()
  @type opts :: Keyword.t()

  @spec bin_to_hex(key_bin :: binary()) :: key()
  def bin_to_hex(key_bin), do: Base.encode16(key_bin, case: :lower)

  @spec hex_to_bin(key :: key()) :: binary()
  def hex_to_bin(key), do: Base.decode16!(key, case: :lower)

  @spec url_encode64(hash_bin :: binary()) :: hash()
  def url_encode64(hash_bin), do: Base.url_encode64(hash_bin, padding: false)

  @spec url_decode64(hash :: hash()) :: binary()
  def url_decode64(hash), do: Base.url_decode64!(hash, padding: false)

  @spec blake2b_hash(str :: str(), opts :: opts()) :: binary()
  def blake2b_hash(str, opts \\ [])

  def blake2b_hash(str, opts) do
    byte_size = Keyword.get(opts, :byte_size, 32)
    Blake2.hash2b(str, byte_size)
  end
end
