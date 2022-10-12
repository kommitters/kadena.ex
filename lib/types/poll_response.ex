defmodule Kadena.Types.PollResponse do
  @moduledoc """
  `PollResponse` struct definition.
  """

  alias Kadena.Types.Base64UrlsList

  @behaviour Kadena.Types.Spec

  @type request_keys :: Base64UrlsList.t()

  @type t :: %__MODULE__{request_keys: request_keys()}

  defstruct [:request_keys]

  @impl true
  def new(%Base64UrlsList{} = urls), do: %__MODULE__{request_keys: urls}

  def new(urls) do
    case Base64UrlsList.new(urls) do
      %Base64UrlsList{} = urls -> %__MODULE__{request_keys: urls}
      error -> error
    end
  end
end
