defmodule Kadena.Types.CommandsList do
  @moduledoc """
  `CommandsList` struct definition.
  """
  alias Kadena.Types.Command

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type command :: Command.t()
  @type commands :: list(command())
  @type raw_commands :: list()
  @type error_list :: Keyword.t()

  @type t :: %__MODULE__{commands: commands(), json: json()}

  defstruct commands: [], json: ""

  @impl true
  def new(commands), do: build_list(%__MODULE__{json: "["}, commands)

  @spec build_list(list :: t(), commands :: raw_commands()) :: t() | {:error, error_list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{commands: list} = module, [%Command{} = command | rest]) do
    build_list(
      %__MODULE__{commands: list ++ [command], json: concatenate_json(module, command, rest)},
      rest
    )
  end

  defp build_list(%__MODULE__{commands: list} = module, [command | rest]) do
    case Command.new(command) do
      %Command{} = command ->
        build_list(
          %__MODULE__{commands: list ++ [command], json: concatenate_json(module, command, rest)},
          rest
        )

      {:error, reason} ->
        {:error, [commands: :invalid] ++ reason}
    end
  end

  defp build_list(_list, _commands), do: {:error, [commands: :not_a_list]}

  @spec concatenate_json(module :: t(), command :: command(), rest :: list()) :: json()
  defp concatenate_json(%__MODULE__{json: json}, %Command{json: command_json}, []),
    do: json <> command_json <> "]"

  defp concatenate_json(%__MODULE__{json: json}, %Command{json: command_json}, _rest),
    do: json <> command_json <> ","
end
