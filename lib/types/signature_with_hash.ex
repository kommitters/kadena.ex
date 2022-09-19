defmodule Kadena.Types.SignatureWithHash do
  @moduledoc """
  `SignatureWithHash` struct definition.
  """

  alias Kadena.Types.{SignedSignatureWithHash, UnsignedSignatureWithHash}

  @behaviour Kadena.Types.Spec

  @type signature :: SignedSignatureWithHash.t() | UnsignedSignatureWithHash.t()

  @type t :: %__MODULE__{signature: signature()}

  defstruct [:signature]

  @impl true
  def new(%SignedSignatureWithHash{} = signature), do: %__MODULE__{signature: signature}
  def new(%UnsignedSignatureWithHash{} = signature), do: %__MODULE__{signature: signature}
  def new(_sig), do: {:error, :invalid_signature_with_hash}
end
