defmodule Kadena.Pact.Exp do
  @moduledoc """
  Implementation for `Pact.Exp` functions.
  """

  alias Kadena.Pact.Exp

  @behaviour Exp.Spec

  @impl true
  def create_exp(args), do: impl().create_exp(args)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :pact_exp_impl, Exp.Default)
end
