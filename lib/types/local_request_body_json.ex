defmodule Kadena.Types.LocalRequestBodyJSON do
  @moduledoc """
  `LocalRequestBodyJSON` struct definition.
  """
  alias Kadena.Utils.MapCase

  alias Kadena.Types.{
    CommandPayloadStringifiedJSON,
    LocalRequestBody,
    PactTransactionHash,
    SignaturesList
  }

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type signatures_list :: SignaturesList.t()
  @type signatures :: list(map())

  @type t :: %__MODULE__{json: json()}

  defstruct [:json]

  @impl true
  def new(%LocalRequestBody{hash: hash, sigs: sigs, cmd: cmd}) do
    with %PactTransactionHash{hash: hash} <- hash,
         {:ok, sigs} <- to_signature_list(sigs),
         %CommandPayloadStringifiedJSON{json_string: cmd} <- cmd do
      request_body =
        %{hash: hash, sigs: sigs, cmd: cmd}
        |> MapCase.to_camel!()
        |> Jason.encode!()

      %__MODULE__{json: request_body}
    end
  end

  @spec to_signature_list(signatures :: signatures_list()) :: {:ok, signatures()}
  defp to_signature_list(%SignaturesList{signatures: list}) do
    sigs = Enum.map(list, fn sig -> Map.from_struct(sig) end)
    {:ok, sigs}
  end
end
