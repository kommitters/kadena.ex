defmodule Kadena.Chainweb.Pact.API.ExecCommandRequest do
  @moduledoc """
  Specifies functions to build PACT execution command requests.
  """

  alias Kadena.Chainweb.Pact.{API.CommandRequest, JSONPayload}
  alias Kadena.Cryptography.Sign

  alias Kadena.Types.{
    Command,
    CommandPayload,
    EnvData,
    ExecPayload,
    KeyPair,
    MetaData,
    NetworkID,
    PactPayload,
    Signature,
    SignaturesList,
    SignCommand,
    Signer,
    SignersList
  }

  @behaviour CommandRequest

  @type network_id :: NetworkID.t()
  @type code :: String.t()
  @type data :: EnvData.t() | nil
  @type nonce :: String.t()
  @type meta_data :: MetaData.t()
  @type keypair :: KeyPair.t()
  @type keypairs :: list(keypair())
  @type signer :: Signer.t()
  @type signers :: list(signer) | SignersList.t()
  @type hash :: String.t()
  @type sign_command :: SignCommand.t()

  @type t :: %__MODULE__{
          network_id: network_id(),
          code: code(),
          data: data(),
          nonce: nonce(),
          meta_data: meta_data(),
          keypairs: keypairs(),
          signers: signers()
        }

  defstruct [:network_id, :code, :data, :nonce, :meta_data, keypairs: [], signers: []]

  @impl true
  def new, do: %__MODULE__{}

  @impl true
  def set_network(%__MODULE__{} = cmd_request, network) do
    network_id = NetworkID.new(network)
    Map.put(cmd_request, :network_id, network_id)
  end

  @impl true
  def set_data(%__MODULE__{} = cmd_request, data) do
    case ExecPayload.new(data: data, code: "") do
      %ExecPayload{} -> Map.put(cmd_request, :data, data)
    end
  end

  @impl true
  def set_code(%__MODULE__{} = cmd_request, code) when is_binary(code),
    do: Map.put(cmd_request, :code, code)

  @impl true
  def set_nonce(%__MODULE__{} = cmd_request, nonce), do: Map.put(cmd_request, :nonce, nonce)

  @impl true
  def set_metadata(%__MODULE__{} = cmd_request, %MetaData{} = meta_data),
    do: Map.put(cmd_request, :meta_data, meta_data)

  @impl true
  def add_keypair(%__MODULE__{} = cmd_request, %KeyPair{} = keypair),
    do: Map.put(cmd_request, :keypairs, [keypair])

  @impl true
  def add_keypairs(%__MODULE__{} = cmd_request, keypairs) when is_list(keypairs),
    do: Map.put(cmd_request, :keypairs, keypairs)

  @impl true
  def add_signer(%__MODULE__{} = cmd_request, %Signer{} = signer),
    do: Map.put(cmd_request, :signers, [signer])

  @impl true
  def add_signers(%__MODULE__{} = cmd_request, %SignersList{signers: signers}),
    do: Map.put(cmd_request, :signers, signers)

  def add_signers(%__MODULE__{} = cmd_request, signers) when is_list(signers),
    do: Map.put(cmd_request, :signers, signers)

  @impl true
  def build(%__MODULE__{
        network_id: network_id,
        code: code,
        data: data,
        nonce: nonce,
        meta_data: %MetaData{chain_id: chain_id} = meta_data,
        keypairs: keypairs,
        signers: signers
      }) do
    payload =
      [code: code, data: data]
      |> ExecPayload.new()
      |> PactPayload.new()

    cmd =
      [
        network_id: network_id,
        payload: payload,
        meta: meta_data,
        signers: SignersList.new(signers),
        nonce: nonce
      ]
      |> CommandPayload.new()
      |> JSONPayload.parse()

    sigs =
      Enum.map(keypairs, fn keypair ->
        {:ok, sign_command} = Sign.sign(cmd, keypair)
        sign_command
      end)

    signatures =
      sigs
      |> Enum.map(&Signature.new(&1.sig))
      |> SignaturesList.new()

    hash = Enum.reduce(sigs, nil, fn %SignCommand{hash: hash}, _acc -> hash end)

    command = Command.new(hash: hash, sigs: signatures, cmd: cmd)

    %CommandRequest{cmd: command, network_id: network_id, chain_id: chain_id}
  end
end
