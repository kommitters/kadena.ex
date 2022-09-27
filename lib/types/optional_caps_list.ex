defmodule Kadena.Types.OptionalCapsList do
  @moduledoc """
  `OptionalCapsList` struct definition.
  """
  alias Kadena.Types.CapsList

  @behaviour Kadena.Types.Spec

  @type clist :: CapsList.t() | nil

  @type t :: %__MODULE__{clist: clist()}

  defstruct [:clist]

  @impl true
  def new(clist \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(%CapsList{} = clist), do: %__MODULE__{clist: clist}
  def new(_clist), do: {:error, [clist: :invalid]}
end
