defmodule Kadena.Types.LocalRequestBody do
  @moduledoc """
  `LocalRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONRequestBody
  alias Kadena.Types.{Command, PactTransactionHash, SignaturesList}

  @behaviour Kadena.Types.Spec

  @type command :: String.t()
  @type hash :: PactTransactionHash.t()
  @type sigs :: SignaturesList.t()
  @type cmd :: String.t()
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

  defimpl JSONRequestBody do
    alias Kadena.Utils.MapCase

    alias Kadena.Types.LocalRequestBody

    @type signatures_list :: SignaturesList.t()
    @type signatures :: list(map())

    @impl true
    def parse(%LocalRequestBody{hash: hash, sigs: sigs, cmd: cmd}) do
      with %PactTransactionHash{hash: hash} <- hash,
           {:ok, sigs} <- to_signature_list(sigs) do
        %{hash: hash, sigs: sigs, cmd: cmd}
        |> MapCase.to_camel!()
        |> Jason.encode!()
      end
    end

    @spec to_signature_list(signatures :: signatures_list()) :: {:ok, signatures()}
    defp to_signature_list(%SignaturesList{signatures: list}) do
      sigs = Enum.map(list, fn sig -> Map.from_struct(sig) end)
      {:ok, sigs}
    end
  end
end
