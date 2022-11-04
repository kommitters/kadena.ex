defprotocol Kadena.Chainweb.JSON do
  alias Kadena.Types.{
    ListenRequestBody,
    LocalRequestBody,
    PollRequestBody,
    SendRequestBody,
    SPVRequestBody
  }

  @type json_string :: String.t()
  @type request_body ::
          ListenRequestBody.t()
          | LocalRequestBody.t()
          | PollRequestBody.t()
          | SendRequestBody.t()
          | SPVRequestBody.t()

  @spec parse(request_body :: request_body()) :: json_string()
  def parse(request_body)
end

alias Kadena.Chainweb.JSON

defimpl JSON, for: Kadena.Types.LocalRequestBody do
  alias Kadena.Utils.MapCase

  alias Kadena.Types.{
    CommandPayloadStringifiedJSON,
    LocalRequestBody,
    PactTransactionHash,
    SignaturesList
  }

  @type signatures_list :: SignaturesList.t()
  @type signatures :: list(map())

  @impl true
  def parse(%LocalRequestBody{hash: hash, sigs: sigs, cmd: cmd}) do
    with %PactTransactionHash{hash: hash} <- hash,
         {:ok, sigs} <- to_signature_list(sigs),
         %CommandPayloadStringifiedJSON{json_string: cmd} <- cmd do
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
