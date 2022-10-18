defmodule Kadena.Pact.CannedExpImpl do
  @moduledoc false

  @behaviour Kadena.Pact.Exp.Spec

  @impl true
  def create_exp(_args) do
    send(self(), {:create_exp, "EXP"})
    :ok
  end
end

defmodule Kadena.Pact.ExpTest do
  @moduledoc """
  `Pact.Exp` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.{CannedExpImpl, Exp}

  setup do
    Application.put_env(:kadena, :pact_exp_impl, CannedExpImpl)

    on_exit(fn ->
      Application.delete_env(:kadena, :pact_exp_impl)
    end)
  end

  test "create_exp/6" do
    Exp.create_exp("ARGS")
    assert_receive({:create_exp, "EXP"})
  end
end
