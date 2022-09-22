defmodule Kadena.Types.ChainwebResponseMetaData do
  @moduledoc """
  `ChainwebResponseMetaData` struct definition.
  """

  alias Kadena.Types.MetaData

  @behaviour Kadena.Types.Spec

  @type block_hash :: String.t()
  @type block_time :: integer()
  @type block_height :: integer()
  @type prev_block_hash :: String.t()
  @type public_meta :: MetaData.t() | nil
  @type validation :: {:ok, any()} | {:error, atom()}

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

    with {:ok, block_hash} <- validate_block_hash(block_hash),
         {:ok, block_time} <- validate_block_time(block_time),
         {:ok, block_height} <- validate_block_height(block_height),
         {:ok, prev_block_hash} <- validate_prev_block_hash(prev_block_hash),
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

  @spec validate_block_hash(block_hash :: block_hash()) :: validation()
  defp validate_block_hash(block_hash) when is_binary(block_hash), do: {:ok, block_hash}
  defp validate_block_hash(_block_hash), do: {:error, :invalid_block_hash}

  @spec validate_block_time(block_time :: block_time()) :: validation()
  defp validate_block_time(block_time) when is_number(block_time), do: {:ok, block_time}
  defp validate_block_time(_block_time), do: {:error, :invalid_block_time}

  @spec validate_block_height(block_height :: block_height()) :: validation()
  defp validate_block_height(block_height) when is_number(block_height), do: {:ok, block_height}
  defp validate_block_height(_block_height), do: {:error, :invalid_block_height}

  @spec validate_prev_block_hash(prev_block_hash :: prev_block_hash()) :: validation()
  defp validate_prev_block_hash(prev_block_hash) when is_binary(prev_block_hash),
    do: {:ok, prev_block_hash}

  defp validate_prev_block_hash(_prev_block_hash), do: {:error, :invalid_prev_block_hash}

  @spec validate_public_meta(public_meta :: public_meta()) :: validation()
  defp validate_public_meta(%MetaData{} = public_meta), do: {:ok, public_meta}
  defp validate_public_meta(nil), do: {:ok, nil}
  defp validate_public_meta(_public_meta), do: {:error, :invalid_public_meta}
end
