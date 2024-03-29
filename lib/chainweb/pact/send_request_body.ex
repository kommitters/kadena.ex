defmodule Kadena.Chainweb.Pact.SendRequestBody do
  @moduledoc """
  `SendRequestBody` struct definition.
  """

  alias Kadena.Types.{Command, PactTransactionHash, Signature}

  @behaviour Kadena.Chainweb.Type

  @type command :: Command.t()
  @type cmds :: list(command())
  @type raw_cmds :: list(map())
  @type valid_cmds :: {:ok, raw_cmds()}
  @type signatures_list :: list(Signature.t())
  @type hash :: PactTransactionHash.t()
  @type hash_value :: String.t()

  @type t :: %__MODULE__{cmds: cmds()}

  defstruct [:cmds]

  @impl true
  def new([%Command{} | _tail] = cmds), do: %__MODULE__{cmds: cmds}
  def new(_cmds), do: {:error, [commands: :not_a_commands_list]}

  @impl true
  def to_json!(%__MODULE__{cmds: cmds}) do
    with {:ok, cmds} <- extract_cmds(cmds) do
      Jason.encode!(%{cmds: cmds})
    end
  end

  @spec extract_cmds(cmds :: cmds()) :: valid_cmds()
  defp extract_cmds(cmds) do
    cmds = Enum.map(cmds, fn command -> extract_cmds_info(command) end)
    {:ok, cmds}
  end

  @spec extract_cmds_info(command :: command()) :: map()
  defp extract_cmds_info(%Command{hash: hash, sigs: sigs, cmd: cmd}) do
    %{hash: extract_hash(hash), sigs: to_signature_list(sigs), cmd: cmd}
  end

  @spec extract_hash(hash :: hash()) :: hash_value()
  defp extract_hash(%PactTransactionHash{hash: hash}), do: hash

  @spec to_signature_list(signatures_list :: signatures_list()) :: list()
  defp to_signature_list(signatures_list) do
    Enum.map(signatures_list, &Map.from_struct/1)
  end
end
