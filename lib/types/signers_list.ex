defmodule Kadena.Types.SignersList do
  @moduledoc """
  `SignersList` struct definition.
  """
  alias Kadena.Types.Signer

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type signer :: Signer.t()
  @type signers :: list(signer())

  @type t :: %__MODULE__{signers: signers()}

  defstruct signers: [], json: ""

  @impl true
  def new(signers), do: build_list(%__MODULE__{json: "["}, signers)

  @spec build_list(list :: t(), signers :: signers()) :: t() | {:error, Keyword.t()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{signers: list} = module, [value | rest]) do
    case Signer.new(value) do
      %Signer{} = signer ->
        build_list(
          %__MODULE__{signers: [signer | list], json: concatenate_json(module, signer, rest)},
          rest
        )

      {:error, _reason} ->
        {:error, [signers: :invalid]}
    end
  end

  defp build_list(_list, _rest), do: {:error, [signers: :invalid_type]}

  @spec concatenate_json(module :: t(), signer :: signer(), rest :: list()) :: json()
  defp concatenate_json(%__MODULE__{json: json}, %Signer{json: signer_json}, []),
    do: json <> signer_json <> "]"

  defp concatenate_json(%__MODULE__{json: json}, %Signer{json: signer_json}, _rest),
    do: json <> signer_json <> ","
end
