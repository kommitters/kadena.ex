defmodule Kadena.Types.Provenance do
  @moduledoc """
  `Provenance` struct definition.
  """

  alias Kadena.Types.ChainID

  @behaviour Kadena.Types.Spec

  @type chain_id :: ChainID.t()
  @type target_chain_id :: String.t()
  @type module_hash :: String.t()
  @type value :: chain_id() | module_hash()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          target_chain_id: chain_id(),
          module_hash: module_hash()
        }

  defstruct [:target_chain_id, :module_hash]

  @impl true
  def new(args) do
    target_chain_id = Keyword.get(args, :target_chain_id)
    module_hash = Keyword.get(args, :module_hash)

    with {:ok, chain_id} <- validate_target_chain_id(target_chain_id),
         {:ok, hash} <- validate_module_hash(module_hash) do
      %__MODULE__{target_chain_id: chain_id, module_hash: hash}
    end
  end

  @spec validate_target_chain_id(target_chain_id :: target_chain_id()) :: validation()
  defp validate_target_chain_id(target_chain_id) do
    case ChainID.new(target_chain_id) do
      %ChainID{} = chain_id -> {:ok, chain_id}
      {:error, _reason} -> {:error, [target_chain_id: :invalid]}
    end
  end

  @spec validate_module_hash(module_hash :: module_hash()) :: validation()
  defp validate_module_hash(module_hash) when is_binary(module_hash), do: {:ok, module_hash}
  defp validate_module_hash(_module_hash), do: {:error, [module_hash: :invalid]}
end
