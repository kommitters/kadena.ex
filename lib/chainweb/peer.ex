defmodule Kadena.Chainweb.Peer do
  @moduledoc """
  `Peer` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type address :: map() | nil
  @type id :: String.t() | nil
  @type error :: {:error, Keyword.t()}
  @type result :: t() | error()
  @type validation :: {:ok, map()} | error()

  @type t :: %__MODULE__{
          address: address(),
          id: id()
        }

  defstruct [:id, :address]

  @impl true
  def new(attrs \\ nil)

  def new(attrs) when is_list(attrs) do
    id = Keyword.get(attrs, :id)
    address = Keyword.get(attrs, :address)

    %__MODULE__{}
    |> set_id(id)
    |> set_address(address)
  end

  def new(_attrs), do: %__MODULE__{}

  @spec set_address(peer :: t(), address :: address()) :: result()
  def set_address(%__MODULE__{} = peer, %{} = address) do
    with {:ok, _address} <- validate_origin_address(address) do
      %{peer | address: address}
    end
  end

  def set_address(%__MODULE__{}, _address), do: {:error, [address: :not_a_map]}

  @spec set_id(peer :: t(), id :: id()) :: result()
  def set_id(%__MODULE__{} = peer, id) when is_binary(id), do: %{peer | id: id}
  def set_id(%__MODULE__{} = peer, nil), do: peer
  def set_id(%__MODULE__{}, _id), do: {:error, [id: :invalid]}

  @spec validate_origin_address(address :: address()) :: validation()
  defp validate_origin_address(%{hostname: hostname, port: port} = address)
       when is_binary(hostname) and port >= 0,
       do: {:ok, address}

  defp validate_origin_address(_address), do: {:error, [address: [args: :invalid]]}
end
