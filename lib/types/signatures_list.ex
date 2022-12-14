defmodule Kadena.Types.SignaturesList do
  @moduledoc """
  `SignaturesList` struct definition.
  """
  alias Kadena.Types.Signature

  @behaviour Kadena.Types.Spec

  @type signatures :: list(Signature.t())
  @type raw_signatures :: list()
  @type error_list :: Keyword.t()

  @type t :: %__MODULE__{signatures: signatures()}

  defstruct signatures: []

  @impl true
  def new(signatures), do: build_list(%__MODULE__{}, signatures)

  @spec build_list(list :: t(), signatures :: raw_signatures()) :: t() | {:error, error_list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{} = signature_list, [nil]), do: %{signature_list | signatures: []}

  defp build_list(%__MODULE__{signatures: list}, [%Signature{} = signature | rest]) do
    build_list(%__MODULE__{signatures: list ++ [signature]}, rest)
  end

  defp build_list(%__MODULE__{signatures: list}, [signature | rest]) do
    case Signature.new(signature) do
      %Signature{} = signature -> build_list(%__MODULE__{signatures: list ++ [signature]}, rest)
      {:error, reason} -> {:error, [signatures: :invalid] ++ reason}
    end
  end

  defp build_list(_list, _signatures), do: {:error, [signatures: :not_a_list]}
end
