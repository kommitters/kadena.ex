defmodule Kadena.Types.PactResultError do
  @moduledoc """
  `PactResultError` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{status: :failure, error: map()}

  defstruct [:status, :error]

  @impl true
  def new(%{} = errors), do: %__MODULE__{status: :failure, error: errors}
  def new(_errors), do: {:error, :invalid_pact_result}
end
