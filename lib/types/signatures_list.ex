defmodule Kadena.Types.SignaturesList do
  @moduledoc """
  `SignaturesList` struct definition.
  """
  alias Kadena.Types.Signature

  @behaviour Kadena.Types.Spec

  @type signatures :: list(Signature.t())

  @type t :: %__MODULE__{list: signatures()}

  defstruct list: []

  @impl true
  def new(signatures), do: build_list(%__MODULE__{}, signatures)

  @spec build_list(list :: t(), signatures :: signatures()) :: t()
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [%Signature{} = signature | rest]),
    do: build_list(%__MODULE__{list: [signature | list]}, rest)

  defp build_list(_list, _signatures), do: {:error, :invalid_signature}
end
