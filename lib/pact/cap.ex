defmodule Kadena.Pact.Cap do
  @moduledoc """
  Implementation for `Pact.Cap` functions.
  """
  alias Kadena.Pact.Cap

  @behaviour Cap.Spec

  @impl true
  def create_cap(name, values), do: impl().create_cap(name, values)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :pact_cap_impl, Cap.Default)
end
