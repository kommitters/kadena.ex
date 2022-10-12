defmodule Kadena.Types.CommandPayloadStringifiedJSON do
  @moduledoc """
  `CommandPayloadStringifiedJSON` struct definition.
  """

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type t :: %__MODULE__{json_string: str()}

  defstruct [:json_string]

  @impl true
  def new(json_string) when is_binary(json_string), do: %__MODULE__{json_string: json_string}
  def new(_json_string), do: {:error, [json_string: :invalid]}
end
