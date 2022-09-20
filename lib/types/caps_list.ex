defmodule Kadena.Types.CapsList do
  @moduledoc """
  `CapsList` struct definition.
  """
  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type caps :: list(Cap.t())

  @type t :: %__MODULE__{list: caps()}

  defstruct list: []

  @impl true
  def new(caps), do: build_list(%__MODULE__{}, caps)

  @spec build_list(list :: t(), caps :: caps()) :: t()
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [%Cap{} = cap | rest]),
    do: build_list(%__MODULE__{list: [cap | list]}, rest)

  defp build_list(_list, _caps), do: {:error, :invalid_cap}
end
