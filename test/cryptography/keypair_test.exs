defmodule Kadena.Cryptography.CannedKeyPairImpl do
  @moduledoc false

  @behaviour Kadena.Cryptography.KeyPair.Spec

  @impl true
  def generate do
    send(self(), {:generate, "KEY"})
    :ok
  end

  @impl true
  def from_secret_key(_secret) do
    send(self(), {:from_secret_key, "KEYPAIR"})
    :ok
  end
end

defmodule Kadena.Cryptography.KeyPairTest do
  @moduledoc """
  `Cryptography.KeyPair` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.{CannedKeyPairImpl, KeyPair}

  setup do
    Application.put_env(:kadena, :crypto_sign_impl, CannedKeyPairImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :crypto_sign_impl)
    end)
  end

  test "generate/0" do
    KeyPair.generate()
    assert_receive({:generate, "KEY"})
  end

  test "from_secret_key/0" do
    KeyPair.from_secret_key("KEY")
    assert_receive({:from_secret_key, "KEYPAIR"})
  end
end
