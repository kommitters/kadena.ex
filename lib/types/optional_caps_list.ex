defmodule Kadena.Types.OptionalCapsList do
  @moduledoc """
  `OptionalCapsList` struct definition.
  """
  alias Kadena.Types.Cap

  @behaviour Kadena.Types.Spec

  @type clist :: list(Cap.t()) | nil

  @type t :: %__MODULE__{clist: clist()}

  defstruct [:clist]

  @impl true
  def new(clist \\ nil)
  def new(nil), do: %__MODULE__{}
  def new([%Cap{} | _tail] = clist), do: %__MODULE__{clist: clist}
  def new(_clist), do: {:error, [clist: :invalid]}
end
