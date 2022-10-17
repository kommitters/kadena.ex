defmodule Kadena.Pact.Cap.Default do
  @moduledoc """
  Default implementation for `Pact.Cap`.
  """

  alias Kadena.Types.Cap

  @behaviour Kadena.Pact.Cap.Spec

  @impl true
  def create_cap(name, values) do
    case Cap.new(name: name, args: values) do
      %Cap{} = cap -> {:ok, cap}
      error -> error
    end
  end
end
