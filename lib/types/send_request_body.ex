defmodule Kadena.Types.SendRequestBody do
  @moduledoc """
  `SendRequestBody` struct definition.
  """

  alias Kadena.Types.CommandsList

  @behaviour Kadena.Types.Spec

  @type cmds :: CommandsList.t()

  @type t :: %__MODULE__{cmds: cmds()}

  defstruct [:cmds]

  @impl true
  def new(cmds) when is_list(cmds) do
    case CommandsList.new(cmds) do
      %CommandsList{} = cmds -> %__MODULE__{cmds: cmds}
      {:error, _reason} -> {:error, [commands: :invalid]}
    end
  end

  def new(%CommandsList{} = cmds), do: %__MODULE__{cmds: cmds}
  def new(_cmds), do: {:error, [commands: :not_a_list]}
end
