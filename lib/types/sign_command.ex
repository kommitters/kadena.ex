defmodule Kadena.Types.SignCommand do
  @moduledoc """
  `SignCommand` struct definition.
  """
  alias Kadena.Types.SignatureWithHash

  @behaviour Kadena.Types.Spec

  @type hash :: String.t()
  @type sig :: String.t() | nil
  @type pub_key :: String.t() | nil
  @type sig_type :: :unsigned_signature | :signed_signature
  @type sig_with_hash :: SignatureWithHash.t()

  @type t :: %__MODULE__{hash: hash(), sig: sig(), pub_key: pub_key(), type: sig_type()}

  defstruct [:hash, :sig, :pub_key, :type]

  @impl true
  def new(args) do
    args
    |> SignatureWithHash.new()
    |> build_sign_command()
  end

  @spec build_sign_command(signature :: sig_with_hash()) :: t()
  defp build_sign_command(%SignatureWithHash{} = signature) do
    attrs = Map.from_struct(signature)
    struct(%__MODULE__{}, attrs)
  end

  defp build_sign_command(error), do: error
end
