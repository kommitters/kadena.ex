defmodule Kadena.Types.SignersList do
  @moduledoc """
  `SignersList` struct definition.
  """
  alias Kadena.Types.Signer

  @behaviour Kadena.Types.Spec

  @type signer :: Signer.t()
  @type signers :: list(signer())

  @type t :: %__MODULE__{signers: signers()}

  defstruct signers: []

  @impl true
  def new(signers), do: build_list(%__MODULE__{}, signers)

  @spec build_list(list :: t(), signers :: signers()) :: t() | {:error, Keyword.t()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{signers: list}, [value | rest]) do
    case Signer.new(value) do
      %Signer{} = signer -> build_list(%__MODULE__{signers: [signer | list]}, rest)
      {:error, _reason} -> {:error, [signers: :invalid]}
    end
  end

  defp build_list(_list, _rest), do: {:error, [signers: :invalid_type]}
end
