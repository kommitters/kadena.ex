defmodule Kadena.Types.CommandsList do
  @moduledoc """
  `CommandsList` struct definition.
  """
  alias Kadena.Types.Command

  @behaviour Kadena.Types.Spec

  @type commands :: list(Command.t())
  @type raw_commands :: list()
  @type error_list :: Keyword.t()

  @type t :: %__MODULE__{commands: commands()}

  defstruct commands: []

  @impl true
  def new(commands), do: build_list(%__MODULE__{}, commands)

  @spec build_list(list :: t(), commands :: raw_commands()) :: t() | {:error, error_list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{commands: list}, [%Command{} = command | rest]) do
    build_list(%__MODULE__{commands: list ++ [command]}, rest)
  end

  defp build_list(%__MODULE__{commands: list}, [command | rest]) do
    case Command.new(command) do
      %Command{} = command -> build_list(%__MODULE__{commands: list ++ [command]}, rest)
      {:error, reason} -> {:error, [commands: :invalid] ++ reason}
    end
  end

  defp build_list(_list, _commands), do: {:error, [commands: :not_a_list]}
end
