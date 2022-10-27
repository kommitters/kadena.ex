defmodule Kadena.Types.CapsList do
  @moduledoc """
  `CapsList` struct definition.
  """
  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type raw_caps :: list()
  @type error_list :: Keyword.t()
  @type cap :: Cap.t()
  @type caps :: list(cap)

  @type t :: %__MODULE__{caps: caps(), json: json()}

  defstruct caps: [], json: ""

  @impl true
  def new(raw_caps), do: build_list(%__MODULE__{json: "["}, raw_caps)

  @spec build_list(struct :: t(), raw_caps :: raw_caps()) :: t() | {:error, error_list()}
  defp build_list(struct, []), do: struct

  defp build_list(%__MODULE__{caps: caps} = module, [raw_cap | rest]) do
    case Cap.new(raw_cap) do
      %Cap{} = cap ->
        build_list(
          %__MODULE__{caps: caps ++ [cap], json: concatenate_json(module, cap, rest)},
          rest
        )

      {:error, _reason} ->
        {:error, [caps: :invalid]}
    end
  end

  defp build_list(_list, _rest), do: {:error, [caps: :not_a_caps_list]}

  @spec concatenate_json(module :: t(), cap :: cap(), rest :: list()) :: json()
  defp concatenate_json(%__MODULE__{json: json}, %Cap{json: cap_json}, []),
    do: json <> cap_json <> "]"

  defp concatenate_json(%__MODULE__{json: json}, %Cap{json: cap_json}, _rest),
    do: json <> cap_json <> ","
end
