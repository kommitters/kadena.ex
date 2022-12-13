defmodule Kadena.Types.MetaData do
  @moduledoc """
  `MetaData` struct definition.
  """

  alias Kadena.Types.ChainID

  @behaviour Kadena.Types.Spec

  @type creation_time :: number()
  @type ttl :: number()
  @type gas_limit :: number()
  @type gas_price :: number()
  @type sender :: String.t()
  @type chain_id :: ChainID.t()
  @type chain_id_arg :: String.t()
  @type values :: creation_time() | ttl() | gas_limit() | gas_price() | sender() | chain_id()
  @type validation :: {:ok, values()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          creation_time: creation_time(),
          ttl: ttl(),
          gas_limit: gas_limit(),
          gas_price: gas_price(),
          sender: sender(),
          chain_id: chain_id()
        }

  defstruct creation_time: 0,
            ttl: 0,
            gas_limit: 0,
            gas_price: 0,
            sender: "",
            chain_id: %ChainID{id: "0"}

  @impl true
  def new, do: %__MODULE__{}

  @impl true
  def new(args) when is_list(args) do
    creation_time = Keyword.get(args, :creation_time)
    ttl = Keyword.get(args, :ttl)
    gas_limit = Keyword.get(args, :gas_limit)
    gas_price = Keyword.get(args, :gas_price)
    sender = Keyword.get(args, :sender)
    chain_id = Keyword.get(args, :chain_id)

    with {:ok, creation_time} <- validate_creation_time(creation_time),
         {:ok, ttl} <- validate_number(:ttl, ttl),
         {:ok, gas_limit} <- validate_number(:gas_limit, gas_limit),
         {:ok, gas_price} <- validate_number(:gas_price, gas_price),
         {:ok, sender} <- validate_sender(sender),
         {:ok, chain_id} <- validate_chain_id(chain_id) do
      %__MODULE__{
        creation_time: creation_time,
        ttl: ttl,
        gas_limit: gas_limit,
        gas_price: gas_price,
        sender: sender,
        chain_id: chain_id
      }
    end
  end

  def new(_args), do: {:error, [args: :not_a_list]}

  @spec validate_creation_time(creation_time :: creation_time()) :: validation()
  defp validate_creation_time(creation_time) when is_number(creation_time),
    do: {:ok, creation_time}

  defp validate_creation_time(_creation_time), do: {:error, [creation_time: :invalid]}

  @spec validate_number(field :: atom(), value :: number()) :: validation()
  defp validate_number(_field, value) when is_number(value),
    do: {:ok, value}

  defp validate_number(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_sender(sender :: sender()) :: validation()
  defp validate_sender(sender) when is_binary(sender),
    do: {:ok, sender}

  defp validate_sender(_sender), do: {:error, [sender: :invalid]}

  @spec validate_chain_id(chain_id :: chain_id_arg()) :: validation()
  defp validate_chain_id(id) do
    case ChainID.new(id) do
      %ChainID{} = chain_id -> {:ok, chain_id}
      _error -> {:error, [chain_id: :invalid]}
    end
  end
end
