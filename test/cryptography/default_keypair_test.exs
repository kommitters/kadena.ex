defmodule Kadena.Cryptography.DefaultKeyPairTest do
  @moduledoc """
  `Cryptography.KeyPair.Default` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.KeyPair
  alias Kadena.Types.KeyPair, as: KeyPairStruct

  describe "generate/0" do
    test "generate a valid keypair" do
      {:ok, %KeyPairStruct{secret_key: secret, pub_key: public}} = KeyPair.generate()

      assert byte_size(secret) == 64
      assert byte_size(public) == 64
    end
  end

  describe "from_secret_key/1" do
    test "with a valid secret key" do
      {:ok, %KeyPairStruct{secret_key: secret, pub_key: expected_public}} = KeyPair.generate()

      {:ok, %KeyPairStruct{secret_key: ^secret, pub_key: ^expected_public}} =
        KeyPair.from_secret_key(secret)
    end
  end
end
