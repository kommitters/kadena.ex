defmodule Kadena.Types.OptionalCapsList do
  @moduledoc """
  `OptionalCapsList` struct definition.
  """
  alias Kadena.Types.CapsList

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type clist :: CapsList.t() | nil

  @type t :: %__MODULE__{clist: clist(), json: json()}

  defstruct [:clist, :json]

  @impl true
  def new(clist \\ nil)
  def new(nil), do: %__MODULE__{json: "[]"}
  def new(%CapsList{json: json} = clist), do: %__MODULE__{clist: clist, json: json}
  def new(_clist), do: {:error, [clist: :invalid]}
end
