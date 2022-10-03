defmodule Kadena.Types.Yield do
  @moduledoc """
  `Yield` struct definition.
  """

  alias Kadena.Types.Provenance

  @behaviour Kadena.Types.Spec

  @type data :: map()
  @type provenance :: Provenance.t() | nil
  @type provenance_arg :: provenance() | list()
  @type value :: data() | provenance_arg()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          data: data(),
          provenance: provenance()
        }

  defstruct [:data, :provenance]

  @impl true
  def new(args) do
    data = Keyword.get(args, :data)
    provenance = Keyword.get(args, :provenance)

    with {:ok, data} <- validate_data(data),
         {:ok, provenance} <- validate_provenance(provenance) do
      %__MODULE__{data: data, provenance: provenance}
    end
  end

  @spec validate_data(data :: data()) :: validation()
  def validate_data(data) when is_map(data), do: {:ok, data}
  def validate_data(_data), do: {:error, [data: :invalid]}

  @spec validate_provenance(provenance :: provenance_arg()) :: validation()
  def validate_provenance(nil), do: {:ok, nil}
  def validate_provenance(%Provenance{} = provenance), do: {:ok, provenance}

  def validate_provenance(provenance) do
    case Provenance.new(provenance) do
      %Provenance{} = provenance -> {:ok, provenance}
      _error -> {:error, [provenance: :invalid]}
    end
  end
end
