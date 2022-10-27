defmodule Kadena.Types.Command do
  @moduledoc """
  `Command` struct definition.
  """

  alias Kadena.Types.{
    CommandPayloadStringifiedJSON,
    PactTransactionHash,
    Signature,
    SignaturesList
  }

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type hash :: PactTransactionHash.t()
  @type raw_hash :: list()
  @type sigs :: SignaturesList.t()
  @type signatures :: list(Signature.t())
  @type raw_sigs :: list()
  @type cmd :: CommandPayloadStringifiedJSON.t()
  @type raw_cmd :: list()
  @type value :: hash() | sigs() | cmd()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{hash: hash(), sigs: sigs(), cmd: cmd(), json: json()}

  defstruct [:hash, :sigs, :cmd, :json]

  @impl true
  def new(args) when is_list(args) do
    hash = Keyword.get(args, :hash)
    sigs = Keyword.get(args, :sigs)
    cmd = Keyword.get(args, :cmd)

    with {:ok, hash} <- validate_hash(hash),
         {:ok, sigs} <- validate_sigs(sigs),
         {:ok, cmd} <- validate_cmd(cmd),
         {:ok, json} <- to_json(hash, sigs, cmd) do
      %__MODULE__{hash: hash, sigs: sigs, cmd: cmd, json: json}
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
  defp validate_cmd(cmd) do
    case CommandPayloadStringifiedJSON.new(cmd) do
      %CommandPayloadStringifiedJSON{} = cmd -> {:ok, cmd}
      {:error, reason} -> {:error, [cmd: :invalid] ++ reason}
    end
  end

  @spec to_json(hash :: hash(), sigs :: sigs(), cmd :: cmd()) :: {:ok, json()}
  defp to_json(
        %PactTransactionHash{hash: hash},
        %SignaturesList{signatures: sigs},
        %CommandPayloadStringifiedJSON{json_string: cmd}
      ) do
    []
    |> signatures_to_list(sigs)
    |> (&Jason.encode(%{
          hash: hash,
          sigs: &1,
          cmd: cmd
        })).()
  end

  @spec signatures_to_list(list :: list(), signatures :: signatures()) :: list()
  defp signatures_to_list(list, []), do: list

  defp signatures_to_list(list, [%Signature{sig: signature} | rest]) do
    signatures_to_list(list ++ [%{sig: signature}], rest)
  end
end
