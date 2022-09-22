defmodule Kadena.Types.PactPayload do
  @moduledoc """
  `PactPayload` struct definition.
  """

  alias Kadena.Types.{ContPayload, ExecPayload}

  @behaviour Kadena.Types.Spec

  @type cont :: ContPayload.t()
  @type exec :: ExecPayload.t()
  @type payload :: cont() | exec()
  @type t :: %__MODULE__{payload: payload()}

  defstruct [:payload]

  @impl true
  def new(%ContPayload{} = cont),  do: %__MODULE__{payload: cont}
  def new(%ExecPayload{} = exec),  do: %__MODULE__{payload: exec}
  def new(_args),  do: {:error, :invalid_payload}
end
