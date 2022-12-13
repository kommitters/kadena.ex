defmodule Kadena.Chainweb.Pact.Resources.SPVResponse do
  @moduledoc """
  `SPVResponse` struct definition.
  """

  alias Kadena.Types.SPVProof

  @behaviour Kadena.Chainweb.Resource

  @type response :: String.t()
  @type spv_proof :: SPVProof.t() | {:error, Keyword.t()}

  @type t :: %__MODULE__{response: response()}

  defstruct [:response]

  @impl true
  def new(response) do
    response
    |> SPVProof.new()
    |> build_spv_response()
  end

  @spec build_spv_response(spv_proof :: spv_proof()) :: t()
  defp build_spv_response(%SPVProof{value: response}), do: %__MODULE__{response: response}
  defp build_spv_response(_error), do: %__MODULE__{}
end
