defmodule Kadena.Types.Command do
  @moduledoc """
  `Command` struct definition.
  """

  alias Kadena.Types.{PactTransactionHash, Signature}

  @behaviour Kadena.Types.Spec

  @type hash :: PactTransactionHash.t()
  @type sigs :: list(Signature.t())
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

  @spec validate_hash(hash :: hash()) :: validation()
  defp validate_hash(%PactTransactionHash{} = hash), do: {:ok, hash}

  defp validate_hash(hash) do
    case PactTransactionHash.new(hash) do
      %PactTransactionHash{} = hash -> {:ok, hash}
      {:error, _reason} -> {:error, [hash: :invalid]}
    end
  end

  @spec validate_sigs(sigs :: sigs()) :: validation()
  defp validate_sigs([]), do: {:ok, []}
  defp validate_sigs([%Signature{} | _tail] = sigs), do: {:ok, sigs}
  defp validate_sigs(_hash), do: {:error, [sigs: :invalid]}

  @spec validate_cmd(cmd :: raw_cmd()) :: validation()
  defp validate_cmd(cmd) when is_binary(cmd), do: {:ok, cmd}
  defp validate_cmd(_cmd), do: {:error, [cmd: :not_a_string]}
end
