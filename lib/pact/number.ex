defmodule Kadena.Pact.Number do
  @moduledoc """
  Implementation for `Pact.Number` functions.
  """
  alias Kadena.Pact.Number

  @behaviour Number.Spec

  @impl true
  def to_pact_integer(number), do: impl().to_pact_integer(number)

  @impl true
  def to_pact_decimal(decimal), do: impl().to_pact_decimal(decimal)

  @impl true
  def to_stringified(number), do: impl().to_stringified(number)

  @spec impl :: module()
  defp impl, do: Application.get_env(:kadena, :pact_number_impl, Number.Default)
end
