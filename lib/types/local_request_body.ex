defmodule Kadena.Types.LocalRequestBody do
  @moduledoc """
  `LocalRequestBody` struct definition.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Types.{Command, PactTransactionHash, SignaturesList}

  @behaviour Kadena.Types.Spec

  @type command :: Command.t()
  @type hash :: PactTransactionHash.t()
  @type sigs :: SignaturesList.t()
  @type cmd :: String.t()
  @type errors :: {:error, Keyword.t()}

  @type t :: %__MODULE__{hash: hash(), sigs: sigs(), cmd: cmd()}

  defstruct [:hash, :sigs, :cmd]

  @impl true
  def new(%Command{} = command), do: build_local_request_body(command)
  def new(_any), do: {:error, [arg: :not_a_command]}

  @spec build_local_request_body(command :: command()) :: t()
  defp build_local_request_body(%Command{} = command) do
    attrs = Map.from_struct(command)
    struct(%__MODULE__{}, attrs)
  end

  defimpl JSONPayload do
    alias Kadena.Types.LocalRequestBody
    alias Kadena.Utils.MapCase

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
