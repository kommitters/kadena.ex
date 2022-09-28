defmodule Kadena.Types.PactTransactionHash do
  @moduledoc """
  `PactTransactionHash` struct definition.
  """

  alias Kadena.Types.Base64Url

  @behaviour Kadena.Types.Spec

  @type hash :: String.t()
  @type base64_url :: Base64Url.t()

  @type t :: %__MODULE__{hash: hash()}

  defstruct [:hash]

  @impl true
  def new(hash) do
    hash
    |> Base64Url.new()
    |> build_transaction_hash()
  end

  @spec build_transaction_hash(hash :: base64_url()) :: t()
  defp build_transaction_hash(%Base64Url{url: url}), do: %__MODULE__{hash: url}
  defp build_transaction_hash(error), do: error
end
