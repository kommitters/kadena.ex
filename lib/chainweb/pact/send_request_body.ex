defmodule Kadena.Chainweb.Pact.SendRequestBody do
  @moduledoc """
  `SendRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Types.CommandsList

  @behaviour Kadena.Chainweb.Pact.Type

  @type cmds :: CommandsList.t()

  @type t :: %__MODULE__{cmds: cmds()}

  defstruct [:cmds]

  @impl true
  def new(cmds) when is_list(cmds) do
    case CommandsList.new(cmds) do
      %CommandsList{} = cmds -> %__MODULE__{cmds: cmds}
      {:error, _reason} -> {:error, [commands: :invalid]}
    end
  end

  def new(%CommandsList{} = cmds), do: %__MODULE__{cmds: cmds}
  def new(_cmds), do: {:error, [commands: :not_a_list]}

  defimpl JSONPayload do
    alias Kadena.Chainweb.Pact.SendRequestBody
    alias Kadena.Types.{
      Command,
      PactTransactionHash,
      SignaturesList
    }

    @type json_value :: String.t()
    @type map_list :: list(map())
    @type valid_cmds :: {:ok, map_list()}
    @type commands_list :: CommandsList.t()
    @type signatures_list :: SignaturesList.t()
    @type command :: Command.t()
    @type hash :: PactTransactionHash.t()
    @type hash_value :: String.t()

    @impl true
    def parse(%SendRequestBody{cmds: cmds}) do
      with {:ok, cmds} <- extract_cmds(cmds) do
        Jason.encode!(%{cmds: cmds})
      end
    end

    @spec extract_cmds(commands_list()) :: valid_cmds()
    defp extract_cmds(%CommandsList{commands: list_commands}) do
      cmds = Enum.map(list_commands, fn command -> extract_cmds_info(command) end)
      {:ok, cmds}
    end

    @spec extract_cmds_info(command()) :: map()
    defp extract_cmds_info(%Command{hash: hash, sigs: sigs, cmd: cmd}) do
      %{hash: extract_hash(hash), sigs: to_signature_list(sigs), cmd: cmd}
    end

    @spec extract_hash(hash()) :: hash_value()
    defp extract_hash(%PactTransactionHash{hash: hash}), do: hash

    @spec to_signature_list(signatures_list()) :: list()
    defp to_signature_list(%SignaturesList{signatures: list}) do
      Enum.map(list, fn sig -> Map.from_struct(sig) end)
    end
  end
end
