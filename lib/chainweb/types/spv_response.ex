defmodule Kadena.Chainweb.Types.SPVResponse do
  @moduledoc """
  `SPVResponse` struct definition.
  """

  alias Kadena.Types.SPVProof

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type spv_proof :: SPVProof.t()
  @type validation :: t() | {:error, Keyword.t()}

  @type t :: %__MODULE__{response: str()}

  defstruct [:response]

  @impl true
  def new(response) do
    response
    |> SPVProof.new()
    |> build_spv_response()
  end

  @spec build_spv_response(spv_proof :: spv_proof()) :: validation()
  def build_spv_response(%SPVProof{value: response}), do: %__MODULE__{response: response}
  def build_spv_response(_error), do: {:error, [response: :invalid]}
end
