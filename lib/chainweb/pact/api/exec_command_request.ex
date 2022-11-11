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
  @type signers :: SignersList.t()
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

  defstruct [:network_id, :code, :data, :nonce, :meta_data, :signers, keypairs: []]

  @impl true
  def new, do: %__MODULE__{}

  @impl true
  def set_network(%__MODULE__{} = cmd_request, network) do
    case NetworkID.new(network) do
      %NetworkID{} = network_id -> Map.put(cmd_request, :network_id, network_id)
      {:error, reason} -> {:error, [network_id: :invalid] ++ reason}
    end
  end

  def set_network({:error, reason}, _network), do: {:error, reason}

  @impl true
  def set_data(%__MODULE__{} = cmd_request, nil), do: Map.put(cmd_request, :data, nil)

  def set_data(%__MODULE__{} = cmd_request, data) do
    case EnvData.new(data) do
      %EnvData{} -> Map.put(cmd_request, :data, data)
      error -> error
    end
  end

  def set_data({:error, reason}, _data), do: {:error, reason}

  @impl true
  def set_code(%__MODULE__{} = cmd_request, code) when is_binary(code),
    do: Map.put(cmd_request, :code, code)

  def set_code(%__MODULE__{}, _code), do: {:error, [code: :not_a_string]}
  def set_code({:error, reason}, _code), do: {:error, reason}

  @impl true
  def set_nonce(%__MODULE__{} = cmd_request, nonce) when is_binary(nonce),
    do: Map.put(cmd_request, :nonce, nonce)

  def set_nonce(%__MODULE__{}, _nonce), do: {:error, [nonce: :not_a_string]}
  def set_nonce({:error, reason}, _nonce), do: {:error, reason}

  @impl true
  def set_metadata(%__MODULE__{} = cmd_request, %MetaData{} = meta_data),
    do: Map.put(cmd_request, :meta_data, meta_data)

  def set_metadata(%__MODULE__{} = cmd_request, meta_data) do
    case MetaData.new(meta_data) do
      %MetaData{} = meta_data -> Map.put(cmd_request, :meta_data, meta_data)
      {:error, reason} -> {:error, [meta_data: :invalid] ++ reason}
    end
  end

  def set_metadata({:error, reason}, _metadata), do: {:error, reason}

  @impl true
  def add_keypair(%__MODULE__{} = cmd_request, %KeyPair{} = keypair),
    do: Map.put(cmd_request, :keypairs, [keypair])

  def add_keypair(%__MODULE__{} = cmd_request, keypair) do
    case KeyPair.new(keypair) do
      %KeyPair{} = keypair -> Map.put(cmd_request, :keypairs, [keypair])
      {:error, reason} -> {:error, [keypair: :invalid] ++ reason}
    end
  end

  def add_keypair({:error, reason}, _keypair), do: {:error, reason}

  @impl true
  def add_keypairs(%__MODULE__{} = cmd_request, []), do: cmd_request

  def add_keypairs(%__MODULE__{keypairs: keypairs} = cmd_request, [%KeyPair{} = keypair | rest]),
    do: add_keypairs(Map.put(cmd_request, :keypairs, keypairs ++ [keypair]), rest)

  def add_keypairs(%__MODULE__{}, [_keypair | _rest]), do: {:error, [keypairs: :invalid]}
  def add_keypairs(%__MODULE__{}, _keypairs), do: {:error, [keypairs: :not_a_list]}
  def add_keypairs({:error, reason}, _keypairs), do: {:error, reason}

  @impl true
  def add_signer(%__MODULE__{} = cmd_request, %Signer{} = signer),
    do: Map.put(cmd_request, :signers, SignersList.new([signer]))

  def add_signer(%__MODULE__{}, _signer), do: {:error, [signer: :invalid]}
  def add_signer({:error, reason}, _signer), do: {:error, reason}

  @impl true
  def add_signers(%__MODULE__{} = cmd_request, %SignersList{} = list),
    do: Map.put(cmd_request, :signers, list)

  def add_signers(%__MODULE__{} = cmd_request, signers) do
    case SignersList.new(signers) do
      %SignersList{} = list -> Map.put(cmd_request, :signers, list)
      {:error, reason} -> {:error, [signers: :invalid] ++ reason}
    end
  end

  def add_signers({:error, reason}, _signers), do: {:error, reason}

  @impl true
  def build(%__MODULE__{
        network_id: %NetworkID{} = network_id,
        code: code,
        data: data,
        nonce: nonce,
        meta_data: %MetaData{chain_id: chain_id} = meta_data,
        keypairs: [%KeyPair{} | _rest] = keypairs,
        signers: %SignersList{} = signers
      })
      when is_binary(code) and is_binary(nonce) do
    payload =
      [code: code, data: data]
      |> ExecPayload.new()
      |> PactPayload.new()

    cmd =
      [
        network_id: network_id,
        payload: payload,
        meta: meta_data,
        signers: signers,
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

  def build(_module), do: {:error, [exec_command_request: :invalid_format]}
end
