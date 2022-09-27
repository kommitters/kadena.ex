defmodule Kadena.Types.SignersList do
  @moduledoc """
  `SignersList` struct definition.
  """
  alias Kadena.Types.Signer

  @behaviour Kadena.Types.Spec

  @type signers :: list(Signer.t())

  @type t :: %__MODULE__{list: signers()}

  defstruct list: []

  @impl true
  def new(signers), do: build_list(%__MODULE__{}, signers)

  @spec build_list(list :: t(), signers :: signers()) :: t() | {:error, list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [value | rest]) do
    with %Signer{} = signer <- Signer.new(value) do
      build_list(%__MODULE__{list: [signer | list]}, rest)
    end
  end

  defp build_list(_list, _rest), do: {:error, [list: :invalid_type]}
end
