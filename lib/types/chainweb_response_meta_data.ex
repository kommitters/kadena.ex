defmodule Kadena.Types.ChainwebResponseMetaData do
  @moduledoc """
  `ChainwebResponseMetaData` struct definition.
  """

  alias Kadena.Types.{MetaData, OptionalMetaData}

  @behaviour Kadena.Types.Spec

  @type hash :: String.t()
  @type block_hash :: hash()
  @type block_number :: number()
  @type block_time :: block_number()
  @type block_height :: block_number()
  @type prev_block_hash :: hash()
  @type public_meta :: OptionalMetaData.t()
  @type value :: hash() | block_number() | public_meta()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          block_hash: block_hash(),
          block_time: block_time(),
          block_height: block_height(),
          prev_block_hash: prev_block_hash(),
          public_meta: public_meta()
        }

  defstruct [:block_hash, :block_time, :block_height, :prev_block_hash, :public_meta]

  @impl true
  def new(args) do
    block_hash = Keyword.get(args, :block_hash)
    block_time = Keyword.get(args, :block_time)
    block_height = Keyword.get(args, :block_height)
    prev_block_hash = Keyword.get(args, :prev_block_hash)
    public_meta = Keyword.get(args, :public_meta)

    with {:ok, block_hash} <- validate_hash(:block_hash, block_hash),
         {:ok, block_time} <- validate_number(:block_time, block_time),
         {:ok, block_height} <- validate_number(:block_height, block_height),
         {:ok, prev_block_hash} <- validate_hash(:prev_block_hash, prev_block_hash),
         {:ok, public_meta} <- validate_public_meta(public_meta) do
      %__MODULE__{
        block_hash: block_hash,
        block_time: block_time,
        block_height: block_height,
        prev_block_hash: prev_block_hash,
        public_meta: public_meta
      }
    end
  end

  @spec validate_hash(field :: atom(), value :: hash()) :: validation()
  defp validate_hash(_field, value) when is_binary(value), do: {:ok, value}
  defp validate_hash(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_number(field :: atom(), value :: block_number()) :: validation()
  defp validate_number(_field, value) when is_number(value), do: {:ok, value}
  defp validate_number(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_public_meta(value :: public_meta()) :: validation()
  defp validate_public_meta(nil), do: {:ok, OptionalMetaData.new()}
  defp validate_public_meta(%OptionalMetaData{} = value), do: {:ok, value}
  defp validate_public_meta(%MetaData{} = value), do: {:ok, OptionalMetaData.new(value)}

  defp validate_public_meta(value) when is_list(value) do
    with %MetaData{} = meta_data <- MetaData.new(value),
         %OptionalMetaData{} = value <- OptionalMetaData.new(meta_data) do
      {:ok, value}
    else
      {:error, reasons} -> {:error, [public_meta: :invalid] ++ reasons}
    end
  end

  defp validate_public_meta(_value), do: {:error, [public_meta: :invalid]}
end
