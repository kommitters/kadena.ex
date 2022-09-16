defmodule Kadena.Types.Signature do
  @moduledoc """
  `Signature` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type t :: %__MODULE__{
          sig: String.t() | nil
        }

  defstruct [:sig]

  @impl true
  def new(sig) when is_binary(sig) or is_nil(sig), do: %__MODULE__{sig: sig}
  def new(_sig), do: {:error, :invalid_signature}
end
