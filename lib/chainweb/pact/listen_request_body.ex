defmodule Kadena.Chainweb.Pact.ListenRequestBody do
  @moduledoc """
  `ListenRequestBody` struct definition.
  """

  alias Kadena.Types.Base64Url

  @behaviour Kadena.Chainweb.Pact.Type

  @type listen :: Base64Url.t()

  @type t :: %__MODULE__{listen: listen()}

  defstruct [:listen]

  @impl true
  def new(%Base64Url{} = listen), do: %__MODULE__{listen: listen}

  def new(listen) do
    case Base64Url.new(listen) do
      %Base64Url{} = listen -> %__MODULE__{listen: listen}
      {:error, _reasons} -> {:error, [listen: :invalid]}
    end
  end

  @impl true
  def to_json!(%__MODULE__{listen: %Base64Url{url: listen}}) do
    Jason.encode!(%{listen: listen})
  end
end
