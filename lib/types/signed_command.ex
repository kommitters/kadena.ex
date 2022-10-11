defmodule Kadena.Types.SignedCommand do
  @moduledoc """
  `SignedCommand` struct definition.
  """
  alias Kadena.Types.SignaturesList

  @behaviour Kadena.Types.Spec

  @type str :: String.t()
  @type hash :: str()
  @type cmd :: str()
  @type sigs :: SignaturesList.t()
  @type raw_sigs :: list()
  @type value :: str() | sigs()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          hash: hash(),
          sigs: sigs(),
          cmd: cmd()
        }

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(args) do
    hash = Keyword.get(args, :hash)
    sigs = Keyword.get(args, :sigs)
    cmd = Keyword.get(args, :cmd)

    with {:ok, hash} <- validate_str(:hash, hash),
         {:ok, cmd} <- validate_str(:cmd, cmd),
         {:ok, sigs} <- validate_sigs(sigs) do
      %__MODULE__{hash: hash, sigs: sigs, cmd: cmd}
    end
  end

  @spec validate_str(field :: atom(), value :: str()) :: validation()
  defp validate_str(_field, value) when is_binary(value), do: {:ok, value}
  defp validate_str(field, _value), do: {:error, {field, :invalid}}

  @spec validate_sigs(sigs :: raw_sigs()) :: validation()
  defp validate_sigs(sigs) do
    case SignaturesList.new(sigs) do
      %SignaturesList{} = sigs -> {:ok, sigs}
      {:error, reason} -> {:error, [sigs: :invalid] ++ reason}
    end
  end
end
