defmodule Kadena.Types.PactResultSuccess do
  @moduledoc """
  `PactResultSuccess` struct definition.
  """

  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type data :: PactValue.t()
  @type t :: %__MODULE__{status: :success, data: data()}

  defstruct [:status, :data]

  @impl true
  def new(%PactValue{} = data), do: %__MODULE__{status: :success, data: data}
  def new(_data), do: {:error, :invalid_pact_result}
end
