defmodule Kadena.Cryptography.CannedSignImpl do
  @moduledoc false

  @behaviour Kadena.Cryptography.Sign.Spec

  @impl true
  def sign(_msg, _keypair) do
    send(self(), {:sign, "SIG"})
    :ok
  end

  @impl true
  def sign_hash(_hash, _keypair) do
    send(self(), {:sign_hash, "SIGN_HASH"})
    :ok
  end

  @impl true
  def verify_sign(_msg, _sig, _pub_key) do
    send(self(), {:verify_sign, "SIGN_VERIFICATION"})
    :ok
  end
end

defmodule Kadena.Cryptography.SignTest do
  @moduledoc """
  `Cryptography.Sign` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Cryptography.{CannedSignImpl, Sign}

  setup do
    Application.put_env(:kadena, :crypto_sign_impl, CannedSignImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :crypto_sign_impl)
    end)
  end

  test "sign/2" do
    Sign.sign("MSG", "KEY")
    assert_receive({:sign, "SIG"})
  end

  test "sign_hash/2" do
    Sign.sign_hash("HASH", "KEY")
    assert_receive({:sign_hash, "SIGN_HASH"})
  end

  test "verify_sign/3" do
    Sign.verify_sign("MSG", "SIG", "PUB_KEY")
    assert_receive({:verify_sign, "SIGN_VERIFICATION"})
  end
end
