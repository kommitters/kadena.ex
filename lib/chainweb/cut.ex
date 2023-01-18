defmodule Kadena.Chainweb.Cut do
  @moduledoc """
  `Cut` struct definition.
  """
  @behaviour Kadena.Chainweb.Type

  @type hashes :: map() | list()
  @type height :: non_neg_integer()
  @type id :: String.t()
  @type instance :: String.t()
  @type origin :: map() | nil
  @type weight :: String.t()
  @type chain_id :: 0..19 | String.t() | atom()
  @type error :: {:error, Keyword.t()}
  @type result :: t() | error()
  @type validation :: {:ok, map() | chain_id()} | error()

  @type t :: %__MODULE__{
          hashes: hashes(),
          height: height(),
          weight: weight(),
          origin: origin(),
          id: id(),
          instance: instance()
        }

  defstruct [:height, :weight, :id, :instance, :origin, hashes: %{}]

  @impl true
  def new(args \\ [])
  def new(attrs) when is_map(attrs), do: struct(%__MODULE__{}, attrs)
  def new(attrs) when is_list(attrs), do: struct(%__MODULE__{}, attrs)
  def new(_attrs), do: {:error, [args: :invalid_format]}

  @spec set_hashes(cut :: t(), hashes :: hashes()) :: result()
  def set_hashes(%__MODULE__{} = cut, %{} = hashes) do
    keys = Map.keys(hashes)
    validate_hashes(cut, keys, hashes)
  end

  def set_hashes(%__MODULE__{}, _hashes), do: {:error, [hashes: :not_a_map]}

  @spec add_hash(cut :: t(), chain_id :: chain_id(), hash :: map()) :: result()
  def add_hash(
        %__MODULE__{hashes: hashes} = cut,
        chain_id,
        %{hash: hash_value, height: height} = hash
      ) do
    with {:ok, chain_id} <- validate_chain_id(chain_id),
         true <- is_binary(hash_value),
         true <- height >= 0 do
      %{cut | hashes: Map.put(hashes, chain_id, hash)}
    else
      _ -> {:error, [args: :invalid]}
    end
  end

  def add_hash(%__MODULE__{}, _chain_id, _hash), do: {:error, [args: :invalid]}

  @spec remove_hash(cut :: t(), chain_id :: chain_id()) :: result()
  def remove_hash(%__MODULE__{hashes: hashes} = cut, chain_id) when chain_id in 0..19,
    do: %{cut | hashes: Map.delete(hashes, String.to_atom("#{chain_id}"))}

  def remove_hash(_cut, _chain_id), do: {:error, [chain_id: :invalid]}

  @spec set_height(cut :: t(), height :: height()) :: result()
  def set_height(%__MODULE__{} = cut, height) when is_integer(height), do: %{cut | height: height}
  def set_height(%__MODULE__{}, _height), do: {:error, [height: :not_an_integer]}

  @spec set_weight(cut :: t(), weight :: weight()) :: result()
  def set_weight(%__MODULE__{} = cut, weight) when is_binary(weight), do: %{cut | weight: weight}
  def set_weight(%__MODULE__{}, _weight), do: {:error, [weight: :not_a_string]}

  @spec set_origin(cut :: t(), origin :: origin()) :: result()
  def set_origin(%__MODULE__{} = cut, %{id: id, address: address} = origin) when is_map(origin) do
    with {:ok, _id} <- validate_origin_id(id),
         {:ok, _address} <- validate_origin_address(address) do
      %{cut | origin: origin}
    end
  end

  def set_origin(%__MODULE__{}, _origin), do: {:error, [origin: :not_a_map]}

  @spec set_id(cut :: t(), id :: id()) :: result()
  def set_id(%__MODULE__{} = cut, id) when is_binary(id), do: %{cut | id: id}
  def set_id(%__MODULE__{}, _id), do: {:error, [id: :not_a_string]}

  @spec set_instance(cut :: t(), instance :: instance()) :: result()
  def set_instance(%__MODULE__{} = cut, instance) when is_binary(instance),
    do: %{cut | instance: instance}

  def set_instance(%__MODULE__{}, _instance), do: {:error, [instance: :not_a_string]}

  @spec validate_chain_id(chain_id :: chain_id()) :: validation()
  defp validate_chain_id(chain_id) when is_atom(chain_id) do
    chain_id
    |> Atom.to_string()
    |> validate_chain_id()
  end

  defp validate_chain_id(chain_id) when is_binary(chain_id) do
    case String.match?(chain_id, ~r/^1?[0-9]$/) do
      true -> {:ok, String.to_atom(chain_id)}
      false -> {:error, [chain_id: :invalid]}
    end
  end

  defp validate_chain_id(chain_id) when chain_id in 0..19,
    do: {:ok, String.to_atom("#{chain_id}")}

  defp validate_chain_id(_chain_id), do: {:error, [chain_id: :invalid]}

  @spec validate_origin_id(id :: String.t()) :: validation()
  defp validate_origin_id(id) when is_binary(id), do: {:ok, id}
  defp validate_origin_id(_id), do: {:error, [id: :not_a_string]}

  @spec validate_origin_address(address :: map()) :: validation()
  defp validate_origin_address(%{hostname: hostname, port: port} = address)
       when is_binary(hostname) and port >= 0,
       do: {:ok, address}

  defp validate_origin_address(_address), do: {:error, [address: :invalid]}

  @spec validate_hashes(cut :: t(), list(), hashes :: hashes()) :: t() | error()
  defp validate_hashes(%__MODULE__{} = cut, [], _hashes), do: cut

  defp validate_hashes(%__MODULE__{} = cut, [key | rest], hashes) do
    cut
    |> add_hash(key, hashes[key])
    |> validate_hashes(rest, hashes)
  end

  defp validate_hashes({:error, reason}, _keys, _hashes), do: {:error, [hashes: reason]}
end
