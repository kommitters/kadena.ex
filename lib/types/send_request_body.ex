defmodule Kadena.Types.SendRequestBody do
  @moduledoc """
  `SendRequestBody` struct definition.
  """

  alias Kadena.Types.CommandsList

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type cmds :: CommandsList.t()

  @type t :: %__MODULE__{cmds: cmds(), json: json()}

  defstruct [:cmds, :json]

  @impl true
  def new(cmds) when is_list(cmds) do
    case CommandsList.new(cmds) do
      %CommandsList{} = cmds -> %__MODULE__{cmds: cmds, json: to_json(cmds)}
      {:error, _reason} -> {:error, [commands: :invalid]}
    end
  end

  def new(%CommandsList{} = cmds), do: %__MODULE__{cmds: cmds, json: to_json(cmds)}
  def new(_cmds), do: {:error, [commands: :not_a_list]}

  @spec to_json(cmds :: cmds()) :: json()
  defp to_json(%CommandsList{json: json}),
    do: %{cmds: "{cmds}"} |> Jason.encode!() |> String.replace("\"{cmds}\"", json)
end
