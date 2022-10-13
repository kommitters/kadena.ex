defmodule Kadena.Types.LocalRequestBody do
  @moduledoc """
  `LocalRequestBody` struct definition.
  """

  alias Kadena.Types.{Command, CommandPayloadStringifiedJSON, PactTransactionHash, SignaturesList}

  @behaviour Kadena.Types.Spec

  @type command :: String.t()
  @type hash :: PactTransactionHash.t()
  @type sigs :: SignaturesList.t()
  @type cmd :: CommandPayloadStringifiedJSON.t()
  @type errors :: {:error, Keyword.t()}

  @type t :: %__MODULE__{hash: hash(), sigs: sigs(), cmd: cmd()}

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(args) do
    args
    |> Command.new()
    |> build_local_request_body()
  end

  @spec build_local_request_body(command :: command() | errors()) :: t() | errors()
  defp build_local_request_body(%Command{} = command) do
    attrs = Map.from_struct(command)
    struct(%__MODULE__{}, attrs)
  end

  defp build_local_request_body({:error, [command: :not_a_list]}),
    do: {:error, [local_request_body: :not_a_list]}

  defp build_local_request_body({:error, reason}), do: {:error, reason}
end
