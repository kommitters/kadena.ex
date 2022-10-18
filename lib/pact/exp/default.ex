defmodule Kadena.Pact.Exp.Default do
  @moduledoc """
  Default implementation for `Pact.Exp`.
  """

  @behaviour Kadena.Pact.Exp.Spec

  @impl true
  def create_exp(args) when is_list(args) do
    result = Enum.join(args, " ")

    {:ok, "(#{result})"}
  end

  def create_exp(_args), do: {:error, [args: :not_a_list]}
end
