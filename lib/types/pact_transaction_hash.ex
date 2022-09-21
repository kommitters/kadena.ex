defmodule Kadena.Types.PactTransactionHash do
  @moduledoc """
  `PactTransactionHash` struct definition.
  """

  alias Kadena.Types.Base64Url

  @behaviour Kadena.Types.Spec

  @type url :: String.t()
  @type base64_url :: Base64Url.t()

  @type t :: %__MODULE__{url: url()}

  defstruct [:url]

  @impl true
  def new(hash) do
    hash
    |> Base64Url.new()
    |> build_transaction_hash()
  end

  @spec build_transaction_hash(url :: base64_url()) :: t()
  defp build_transaction_hash(%Base64Url{} = url) do
    attrs = Map.from_struct(url)
    struct(%__MODULE__{}, attrs)
  end

  defp build_transaction_hash(error), do: error
end
