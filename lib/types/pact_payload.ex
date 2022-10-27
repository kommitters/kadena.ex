defmodule Kadena.Types.PactPayload do
  @moduledoc """
  `PactPayload` struct definition.
  """

  alias Kadena.Types.{ContPayload, ExecPayload}

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type cont :: ContPayload.t()
  @type exec :: ExecPayload.t()
  @type payload :: cont() | exec()

  @type t :: %__MODULE__{payload: payload(), json: json()}

  defstruct [:payload, :json]

  @impl true
  def new(%ContPayload{json: json} = cont),
    do: %__MODULE__{payload: cont, json: to_json(:cont, json)}

  def new(%ExecPayload{json: json} = exec),
    do: %__MODULE__{payload: exec, json: to_json(:exec, json)}

  def new(_args), do: {:error, [payload: :invalid]}

  @spec to_json(type :: atom(), json :: json()) :: json()
  defp to_json(:cont, json) do
    %{cont: "{cont}"}
    |> Jason.encode!()
    |> String.replace("\"{cont}\"", json)
  end

  defp to_json(:exec, json) do
    %{exec: "{exec}"}
    |> Jason.encode!()
    |> String.replace("\"{exec}\"", json)
  end
end
