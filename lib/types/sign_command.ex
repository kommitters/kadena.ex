defmodule Kadena.Types.SignCommand do
  @moduledoc """
  `SignCommand` struct definition.
  """

  alias Kadena.Types.SignatureWithHash

  @behaviour Kadena.Types.Spec

  @type command :: SignatureWithHash.t()

  @type t :: %__MODULE__{command: command()}

  defstruct [:command]

  @impl true
  def new(%SignatureWithHash{} = signature), do: %__MODULE__{command: signature}
  def new(_sig), do: {:error, :invalid_sign_command}
end
