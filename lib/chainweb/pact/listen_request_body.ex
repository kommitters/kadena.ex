defmodule Kadena.Chainweb.Pact.ListenRequestBody do
  @moduledoc """
  `ListenRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
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

  defimpl JSONPayload do
    alias Kadena.Chainweb.Pact.ListenRequestBody
    @type url :: String.t()
    @type base_64_url :: Base64Url.t()

    @impl true
    def parse(%ListenRequestBody{listen: listen}) do
      listen = extract_listen(listen)
      Jason.encode!(%{listen: listen})
    end

    @spec extract_listen(base_64_url()) :: url()
    defp extract_listen(%Base64Url{url: url}), do: url
  end
end
