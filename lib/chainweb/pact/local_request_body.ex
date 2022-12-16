defmodule Kadena.Chainweb.Pact.LocalRequestBody do
  @moduledoc """
  `LocalRequestBody` struct definition.
  """

  alias Kadena.Types.{Command, PactTransactionHash, SignaturesList}

  @behaviour Kadena.Chainweb.Pact.Type

  @type command :: String.t()
  @type hash :: PactTransactionHash.t()
  @type sigs :: SignaturesList.t()
  @type cmd :: String.t()
  @type error :: {:error, Keyword.t()}
  @type raw_sigs :: list(map())

  @type t :: %__MODULE__{hash: hash(), sigs: sigs(), cmd: cmd()}

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(args) do
    args
    |> Command.new()
    |> build_local_request_body()
  end

  @impl true
  def to_json!(%__MODULE__{hash: hash, sigs: sigs, cmd: cmd}) do
    with %PactTransactionHash{hash: hash} <- hash,
         {:ok, sigs} <- to_signature_list(sigs) do
      Jason.encode!(%{hash: hash, sigs: sigs, cmd: cmd})
    end
  end

  @spec build_local_request_body(command :: command() | error()) :: t() | error()
  defp build_local_request_body(%Command{} = command) do
    attrs = Map.from_struct(command)
    struct(%__MODULE__{}, attrs)
  end

  defp build_local_request_body({:error, [command: :not_a_list]}),
    do: {:error, [local_request_body: :not_a_list]}

  defp build_local_request_body({:error, reason}), do: {:error, reason}

  @spec to_signature_list(signatures :: sigs()) :: {:ok, raw_sigs()}
  defp to_signature_list(%SignaturesList{signatures: list}) do
    sigs = Enum.map(list, fn sig -> Map.from_struct(sig) end)
    {:ok, sigs}
  end
end
