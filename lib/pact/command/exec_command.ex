defmodule Kadena.Pact.ExecCommand do
  @moduledoc """
    Specifies functions to build PACT execution command requests.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Pact.Command.CommandBuilder

  alias Kadena.Types.{
    CommandPayload,
    EnvData,
    ExecPayload,
    KeyPair,
    MetaData,
    NetworkID,
    PactPayload,
    Signer,
    SignersList
  }

  @behaviour Kadena.Pact.Command

  @type code :: String.t()
  @type data :: EnvData.t() | nil
  @type json_string_payload :: String.t()
  @type keypair :: KeyPair.t()
  @type keypairs :: list(keypair())
  @type meta_data :: MetaData.t()
  @type network_id :: NetworkID.t()
  @type nonce :: String.t()
  @type pact_payload :: PactPayload.t()
  @type signers :: SignersList.t()
  @type valid_payload :: {:ok, pact_payload()}
  @type valid_command_json_string :: {:ok, json_string_payload()}

  @type t :: %__MODULE__{
          network_id: network_id(),
          code: code(),
          data: data(),
          nonce: nonce(),
          meta_data: meta_data(),
          keypairs: keypairs(),
          signers: signers()
        }

  defstruct [:network_id, :meta_data, :code, :nonce, :signers, :data, keypairs: []]

  @impl true
  def new(opts \\ nil)

  def new(opts) when is_list(opts) do
    network_id = Keyword.get(opts, :network_id)
    code = Keyword.get(opts, :code, "")
    data = Keyword.get(opts, :data)
    nonce = Keyword.get(opts, :nonce, "")
    meta_data = Keyword.get(opts, :meta_data, %MetaData{})
    keypairs = Keyword.get(opts, :keypairs, [])
    signers = Keyword.get(opts, :signers, %SignersList{})

    %__MODULE__{}
    |> set_network(network_id)
    |> set_data(data)
    |> set_code(code)
    |> set_nonce(nonce)
    |> set_metadata(meta_data)
    |> add_keypairs(keypairs)
    |> add_signers(signers)
  end

  def new(_opts), do: %__MODULE__{}

  @impl true
  def set_network(%__MODULE__{} = cmd_request, network) do
    case NetworkID.new(network) do
      %NetworkID{} = network_id -> %{cmd_request | network_id: network_id}
      {:error, reason} -> {:error, [network_id: :invalid] ++ reason}
    end
  end

  def set_network({:error, reason}, _network), do: {:error, reason}

  @impl true
  def set_data(%__MODULE__{} = cmd_request, data) do
    case EnvData.new(data) do
      %EnvData{} -> %{cmd_request | data: data}
      error -> error
    end
  end

  def set_data({:error, reason}, _data), do: {:error, reason}

  @impl true
  def set_code(%__MODULE__{} = cmd_request, code) when is_binary(code),
    do: %{cmd_request | code: code}

  def set_code(%__MODULE__{}, _code), do: {:error, [code: :not_a_string]}
  def set_code({:error, reason}, _code), do: {:error, reason}

  @impl true
  def set_nonce(%__MODULE__{} = cmd_request, nonce) when is_binary(nonce),
    do: %{cmd_request | nonce: nonce}

  def set_nonce(%__MODULE__{}, _nonce), do: {:error, [nonce: :not_a_string]}
  def set_nonce({:error, reason}, _nonce), do: {:error, reason}

  @impl true
  def set_metadata(%__MODULE__{} = cmd_request, %MetaData{} = meta_data),
    do: %{cmd_request | meta_data: meta_data}

  def set_metadata(%__MODULE__{}, _metadata), do: {:error, [metadata: :invalid]}
  def set_metadata({:error, reason}, _metadata), do: {:error, reason}

  @impl true
  def add_keypair(%__MODULE__{keypairs: keypairs} = cmd_request, %KeyPair{} = keypair),
    do: %{cmd_request | keypairs: keypairs ++ [keypair]}

  def add_keypair(%__MODULE__{}, _keypair), do: {:error, [keypair: :invalid]}
  def add_keypair({:error, reason}, _keypair), do: {:error, reason}

  @impl true
  def add_keypairs(%__MODULE__{} = cmd_request, []), do: cmd_request

  def add_keypairs(%__MODULE__{} = cmd_request, [keypair | keypairs]) do
    cmd_request
    |> add_keypair(keypair)
    |> add_keypairs(keypairs)
  end

  def add_keypairs(%__MODULE__{}, _keypairs), do: {:error, [keypairs: :not_a_list]}
  def add_keypairs({:error, reason}, _keypairs), do: {:error, reason}

  @impl true
  def add_signer(%__MODULE__{signers: nil} = cmd_request, %Signer{} = signer),
    do: %{cmd_request | signers: SignersList.new([signer])}

  def add_signer(%__MODULE__{signers: signer_list} = cmd_request, %Signer{} = signer) do
    %SignersList{signers: signers} = signer_list
    %{cmd_request | signers: SignersList.new(signers ++ [signer])}
  end

  def add_signer(%__MODULE__{}, _signer), do: {:error, [signer: :invalid]}
  def add_signer({:error, reason}, _signer), do: {:error, reason}

  @impl true
  def add_signers(%__MODULE__{} = cmd_request, %SignersList{} = list),
    do: %{cmd_request | signers: list}

  def add_signers(%__MODULE__{}, _signers), do: {:error, [signers: :invalid]}
  def add_signers({:error, reason}, _signers), do: {:error, reason}

  @impl true
  def build(
        %__MODULE__{
          keypairs: keypairs,
          code: code,
          data: data
        } = cmd_request
      ) do
    with {:ok, payload} <- create_payload(code, data),
         {:ok, cmd} <- command_to_json_string(payload, cmd_request),
         {:ok, sig_commands} <- CommandBuilder.sign_commands([], cmd, keypairs),
         {:ok, hash} <- CommandBuilder.get_unique_hash(sig_commands),
         {:ok, signatures} <- CommandBuilder.build_signatures(sig_commands, []),
         {:ok, command} <- CommandBuilder.create_command(hash, signatures, cmd) do
      command
    end
  end

  def build(_module), do: {:error, [exec_command_request: :invalid_payload]}

  @spec create_payload(code :: code(), data :: data()) :: valid_payload()
  defp create_payload(code, data) do
    [code: code, data: data]
    |> ExecPayload.new()
    |> PactPayload.new()
    |> (&{:ok, &1}).()
  end

  @spec command_to_json_string(payload :: pact_payload(), t()) :: valid_command_json_string()
  defp command_to_json_string(payload, %__MODULE__{
         network_id: network_id,
         meta_data: meta_data,
         signers: signers,
         nonce: nonce
       }) do
    [
      network_id: network_id,
      payload: payload,
      meta: meta_data,
      signers: signers,
      nonce: nonce
    ]
    |> CommandPayload.new()
    |> JSONPayload.parse()
    |> (&{:ok, &1}).()
  end
end
