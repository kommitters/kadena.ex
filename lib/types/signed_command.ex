defmodule Kadena.Types.SignedCommand do
  @moduledoc """
  `SignedCommand` struct definition.
  """
  alias Kadena.Types.SignaturesList

  @behaviour Kadena.Types.Spec

  @type sigs :: SignaturesList.t()

  @type t :: %__MODULE__{
          hash: String.t(),
          sigs: sigs(),
          cmd: String.t()
        }

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(args) do
    hash = Keyword.get(args, :hash)
    sigs = Keyword.get(args, :sigs)
    cmd = Keyword.get(args, :cmd)

    with hash when is_binary(hash) <- hash,
         cmd when is_binary(cmd) <- cmd,
         %SignaturesList{} <- sigs do
      %__MODULE__{hash: hash, sigs: sigs, cmd: cmd}
    else
      _error -> {:error, :invalid_signed_command}
    end
  end
end
