defmodule Kadena.Pact.CannedCapImpl do
  @moduledoc false

  @behaviour Kadena.Pact.Cap.Spec

  @impl true
  def create_cap(_name, _values) do
    send(self(), {:create_cap, "CAP"})
    :ok
  end
end

defmodule Kadena.Pact.CapTest do
  @moduledoc """
  `Pact.Cap` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.{CannedCapImpl, Cap}

  setup do
    Application.put_env(:kadena, :pact_cap_impl, CannedCapImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :pact_cap_impl)
    end)
  end

  test "create_cap/2" do
    Cap.create_cap("NAME", "VALUES")
    assert_receive({:create_cap, "CAP"})
  end
end
