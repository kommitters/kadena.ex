defmodule Kadena.Types.ListenRequestBody do
  @moduledoc """
  `ListenRequestBody` struct definition.
  """

  alias Kadena.Types.Base64Url

  @behaviour Kadena.Types.Spec

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
end
