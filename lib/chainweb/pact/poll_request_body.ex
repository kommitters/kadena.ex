defmodule Kadena.Chainweb.Pact.PollRequestBody do
  @moduledoc """
  `PollRequestBody` struct definition.
  """

  alias Kadena.Types.Base64Url

  @behaviour Kadena.Chainweb.Pact.Type

  @type urls :: list(String.t())
  @type request_keys :: list(Base64Url.t())
  @type error :: {:error, Keyword.t()}

  @type t :: %__MODULE__{request_keys: request_keys()}

  defstruct request_keys: []

  @impl true
  def new(request_keys) when is_list(request_keys), do: build_list(%__MODULE__{}, request_keys)
  def new(_request_keys), do: {:error, [request_keys: :not_a_list]}

  @impl true
  def to_json!(%__MODULE__{request_keys: key_list}) do
    keys = extract_keys(key_list)
    Jason.encode!(%{requestKeys: keys})
  end

  @spec build_list(list :: t(), urls :: list()) :: t() | error()
  defp build_list(result, []), do: result

  defp build_list(%__MODULE__{request_keys: urls}, [url | rest]) do
    case Base64Url.new(url) do
      %Base64Url{} = url -> build_list(%__MODULE__{request_keys: urls ++ [url]}, rest)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec extract_keys(key_list :: request_keys()) :: urls()
  defp extract_keys(key_list), do: Enum.map(key_list, fn %Base64Url{url: url} -> url end)
end
