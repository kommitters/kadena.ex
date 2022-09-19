defmodule Kadena.Types.Base64UrlsList do
  @moduledoc """
  `Base64UrlsList` struct definition.
  """
  alias Kadena.Types.Base64Url

  @behaviour Kadena.Types.Spec

  @type urls :: list(Base64Url.t())

  @type t :: %__MODULE__{list: urls()}

  defstruct list: []

  @impl true
  def new(urls), do: build_list(%__MODULE__{}, urls)

  @spec build_list(list :: t(), urls :: urls()) :: t()
  defp build_list(list, []), do: list

  defp build_list(%__MODULE__{list: list}, [%Base64Url{} = url | rest]),
    do: build_list(%__MODULE__{list: [url | list]}, rest)

  defp build_list(_list, _urls), do: {:error, :invalid_urls}
end
