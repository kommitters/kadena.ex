defmodule Kadena.Types.OptionalMetaData do
  @moduledoc """
  `OptionalMetaData` struct definition.
  """
  alias Kadena.Types.MetaData

  @behaviour Kadena.Types.Spec

  @type meta_data :: MetaData.t() | nil

  @type t :: %__MODULE__{meta_data: meta_data()}

  defstruct [:meta_data]

  @impl true
  def new(meta_data \\ nil)
  def new(nil), do: %__MODULE__{}
  def new(%MetaData{} = meta_data), do: %__MODULE__{meta_data: meta_data}
  def new(_meta_data), do: {:error, [meta_data: :invalid]}
end
