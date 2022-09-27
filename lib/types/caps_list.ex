defmodule Kadena.Types.CapsList do
  @moduledoc """
  `CapsList` struct definition.
  """
  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type raw_caps :: list()
  @type error_list :: Keyword.t()
  @type caps :: list(Cap.t())

  @type t :: %__MODULE__{caps: caps()}

  defstruct caps: []

  @impl true
  def new(raw_caps), do: build_list(%__MODULE__{}, raw_caps)

  @spec build_list(struct :: t(), raw_caps :: raw_caps()) :: t() | {:error, error_list()}
  defp build_list(struct, []), do: struct

  defp build_list(%__MODULE__{caps: caps}, [raw_cap | rest]) do
    case Cap.new(raw_cap) do
      %Cap{} = cap -> build_list(%__MODULE__{caps: caps ++ [cap]}, rest)
      {:error, _reason} -> {:error, [caps: :invalid]}
    end
  end

  defp build_list(_list, _rest), do: {:error, [caps: :not_a_caps_list]}
end
