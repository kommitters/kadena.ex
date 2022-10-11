defmodule Kadena.Types.Base64UrlsList do
  @moduledoc """
  `Base64UrlsList` struct definition.
  """
  alias Kadena.Types.Base64Url

  @behaviour Kadena.Types.Spec

  @type urls :: list(Base64Url.t())
  @type raw_urls :: list()
  @type error_list :: Keyword.t()

  @type t :: %__MODULE__{urls: urls()}

  defstruct urls: []

  @impl true
  def new(urls), do: build_list(%__MODULE__{}, urls)

  @spec build_list(list :: t(), urls :: raw_urls()) :: t() | {:error, error_list()}
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{urls: list}, [url | rest]) do
    case Base64Url.new(url) do
      %Base64Url{} = url -> build_list(%__MODULE__{urls: [url | list]}, rest)
      {:error, reason} -> {:error, [urls: :invalid] ++ reason}
    end
  end

  defp build_list(_list, _urls), do: {:error, [urls: :not_a_list]}
end
