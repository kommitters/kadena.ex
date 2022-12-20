defmodule Kadena.Chainweb.Pact.PollRequestBody do
  @moduledoc """
  `PollRequestBody` struct definition.
  """

  alias Kadena.Types.{Base64Url, Base64UrlsList}

  @behaviour Kadena.Chainweb.Pact.Type

  @type request_keys :: Base64UrlsList.t()
  @type base64_urls :: Base64UrlsList.t()
  @type urls :: list(String.t())

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

  @impl true
  def to_json!(%__MODULE__{request_keys: key_list}) do
    keys = extract_keys(key_list)
    Jason.encode!(%{requestKeys: keys})
  end

  @spec extract_keys(base64_urls()) :: urls()
  defp extract_keys(%Base64UrlsList{urls: list}),
    do: Enum.map(list, fn %Base64Url{url: url} -> url end)
end
