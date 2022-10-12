defmodule Kadena.Types.SendResponse do
  @moduledoc """
  `SendResponse` struct definition.
  """

  alias Kadena.Types.Base64UrlsList

  @behaviour Kadena.Types.Spec

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
end
