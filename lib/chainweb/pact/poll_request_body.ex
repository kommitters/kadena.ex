defmodule Kadena.Chainweb.Pact.PollRequestBody do
  @moduledoc """
  `PollRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Types.Base64UrlsList
  alias Kadena.Utils.MapCase

  @behaviour Kadena.Chainweb.Pact.Type

  @type request_keys :: Base64UrlsList.t()

  @type t :: %__MODULE__{request_keys: request_keys()}

  defstruct request_keys: []

  @impl true
  def new(request_keys) when is_list(request_keys) do
    case Base64UrlsList.new(request_keys) do
      %Base64UrlsList{} = request_keys -> %__MODULE__{request_keys: request_keys}
      {:error, _reasons} -> {:error, [request_keys: :invalid]}
    end
  end

  def new(%Base64UrlsList{} = request_keys), do: %__MODULE__{request_keys: request_keys}
  def new(_request_keys), do: {:error, [request_keys: :not_a_list]}

  defimpl JSONPayload do
    alias Kadena.Chainweb.Pact.PollRequestBody
    alias Kadena.Types.Base64Url

    @type urls :: list(Base64Url.t())
    @type base64_urls :: Base64UrlsList.t()

    @impl true
    def parse(%PollRequestBody{request_keys: key_list}) do
      keys = extract_keys(key_list)

      %{request_keys: keys}
      |> MapCase.to_camel!()
      |> Jason.encode!()
    end

    @spec extract_keys(base64_urls()) :: urls()
    defp extract_keys(%Base64UrlsList{urls: list}),
      do: Enum.map(list, fn %Base64Url{url: url} -> url end)
  end
end
