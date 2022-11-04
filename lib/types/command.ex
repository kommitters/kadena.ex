defmodule Kadena.Types.Command do
  @moduledoc """
  `Command` struct definition.
  """

  alias Kadena.Types.{PactTransactionHash, SignaturesList}

  @behaviour Kadena.Types.Spec

  @type hash :: PactTransactionHash.t()
  @type raw_hash :: list()
  @type sigs :: SignaturesList.t()
  @type raw_sigs :: list()
  @type cmd :: String.t()
  @type raw_cmd :: list()
  @type value :: hash() | sigs() | cmd()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{hash: hash(), sigs: sigs(), cmd: cmd()}

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(args) when is_list(args) do
    hash = Keyword.get(args, :hash)
    sigs = Keyword.get(args, :sigs)
    cmd = Keyword.get(args, :cmd)

    with {:ok, hash} <- validate_hash(hash),
         {:ok, sigs} <- validate_sigs(sigs),
         {:ok, cmd} <- validate_cmd(cmd) do
      %__MODULE__{hash: hash, sigs: sigs, cmd: cmd}
    end
  end

  def new(_args), do: {:error, [command: :not_a_list]}

  @spec validate_hash(hash :: raw_hash()) :: validation()
  defp validate_hash(hash) do
    case PactTransactionHash.new(hash) do
      %PactTransactionHash{} = hash -> {:ok, hash}
      {:error, _reason} -> {:error, [hash: :invalid]}
    end
  end

  @spec validate_sigs(sigs :: raw_sigs()) :: validation()
  defp validate_sigs(sigs) do
    case SignaturesList.new(sigs) do
      %SignaturesList{} = sigs -> {:ok, sigs}
      {:error, reason} -> {:error, [sigs: :invalid] ++ reason}
    end
  end

  @spec validate_cmd(cmd :: raw_cmd()) :: validation()
  defp validate_cmd(cmd) when is_binary(cmd), do: {:ok, cmd}
  defp validate_cmd(_cmd), do: {:error, [cmd: :not_a_string]}
end
