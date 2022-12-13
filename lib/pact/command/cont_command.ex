defmodule Kadena.Pact.ContCommand do
  @moduledoc """
  Specifies functions to build PACT continuation command requests.
  """
  @behaviour Kadena.Pact.Command

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Cryptography.{Sign, Utils}
  alias Kadena.Pact.Command.Hash

  alias Kadena.Types.{
    Command,
    CommandPayload,
    ContPayload,
    EnvData,
    KeyPair,
    MetaData,
    NetworkID,
    PactPayload,
    SignaturesList,
    SignCommand,
    Signer,
    SignersList
  }

  @type cmd :: String.t()
  @type command :: Command.t()
  @type data :: EnvData.t() | nil
  @type hash :: String.t()
  @type json_string_payload :: String.t()
  @type keypair :: KeyPair.t()
  @type keypairs :: list(keypair())
  @type meta_data :: MetaData.t()
  @type network_id :: NetworkID.t()
  @type nonce :: String.t()
  @type pact_payload :: PactPayload.t()
  @type pact_tx_hash :: String.t()
  @type proof :: String.t() | nil
  @type rollback :: boolean()
  @type signatures :: SignaturesList.t()
  @type signers :: SignersList.t()
  @type sign_command :: SignCommand.t()
  @type sign_commands :: list(sign_command())
  @type step :: number()
  @type valid_command :: {:ok, command()}
  @type valid_command_json_string :: {:ok, json_string_payload()}
  @type valid_payload :: {:ok, pact_payload()}
  @type valid_signatures :: {:ok, signatures()}
  @type valid_sign_commands :: {:ok, sign_commands()}

  @type t :: %__MODULE__{
          network_id: network_id(),
          data: data(),
          nonce: nonce(),
          meta_data: meta_data(),
          pact_tx_hash: pact_tx_hash(),
          step: step(),
          proof: proof(),
          rollback: rollback(),
          keypairs: keypairs(),
          signers: signers()
        }

  defstruct [
    :network_id,
    :data,
    :nonce,
    :meta_data,
    :pact_tx_hash,
    :step,
    :proof,
    :rollback,
    signers: SignersList.new(),
    keypairs: []
  ]

  @impl true
  def new(opts \\ nil)

  def new(opts) when is_list(opts) do
    network_id = Keyword.get(opts, :network_id)
    data = Keyword.get(opts, :data)
    nonce = Keyword.get(opts, :nonce, "")
    meta_data = Keyword.get(opts, :meta_data, MetaData.new())
    pact_tx_hash = Keyword.get(opts, :pact_tx_hash, "")
    step = Keyword.get(opts, :step, 0)
    proof = Keyword.get(opts, :proof)
    rollback = Keyword.get(opts, :rollback, true)
    keypairs = Keyword.get(opts, :keypairs, [])
    signers = Keyword.get(opts, :signers, SignersList.new())

    %__MODULE__{}
    |> set_network(network_id)
    |> set_data(data)
    |> set_nonce(nonce)
    |> set_metadata(meta_data)
    |> add_keypairs(keypairs)
    |> add_signers(signers)
    |> set_pact_tx_hash(pact_tx_hash)
    |> set_proof(proof)
    |> set_step(step)
    |> set_rollback(rollback)
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
  def set_data(%__MODULE__{} = cmd_request, %EnvData{} = data),
    do: %{cmd_request | data: data}

  def set_data(%__MODULE__{} = cmd_request, nil), do: cmd_request

  def set_data(%__MODULE__{} = cmd_request, data) do
    case EnvData.new(data) do
      %EnvData{} -> %{cmd_request | data: data}
      error -> error
    end
  end

  def set_data({:error, reason}, _data), do: {:error, reason}

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
  def add_keypair(%__MODULE__{keypairs: keypairs} = cmd_request, %KeyPair{} = keypair) do
    cmd_request = %{cmd_request | keypairs: keypairs ++ [keypair]}
    set_signers_from_keypair(cmd_request, keypair)
  end

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
  def add_signer(
        %__MODULE__{signers: %SignersList{signers: []}} = cmd_request,
        %Signer{} = signer
      ),
      do: %{cmd_request | signers: SignersList.new([signer])}

  def add_signer(%__MODULE__{signers: signer_list} = cmd_request, %Signer{} = signer) do
    %SignersList{signers: signers} = signer_list
    %{cmd_request | signers: SignersList.new(signers ++ [signer])}
  end

  def add_signer(%__MODULE__{}, _signer), do: {:error, [signer: :invalid]}
  def add_signer({:error, reason}, _signer), do: {:error, reason}

  @impl true
  def add_signers(
        %__MODULE__{signers: %SignersList{signers: []}} = cmd_request,
        %SignersList{} = list
      ),
      do: %{cmd_request | signers: list}

  def add_signers(%__MODULE__{signers: signer_list} = cmd_request, %SignersList{signers: signers}) do
    %SignersList{signers: old_signers} = signer_list
    %{cmd_request | signers: SignersList.new(old_signers ++ signers)}
  end

  def add_signers(%__MODULE__{}, _signers), do: {:error, [signers: :invalid]}
  def add_signers({:error, reason}, _signers), do: {:error, reason}

  @impl true
  def set_pact_tx_hash(%__MODULE__{} = cmd_request, pact_tx_hash) when is_binary(pact_tx_hash),
    do: %{cmd_request | pact_tx_hash: pact_tx_hash}

  def set_pact_tx_hash(%__MODULE__{}, _pact_tx_hash), do: {:error, [pact_tx_hash: :not_a_string]}
  def set_pact_tx_hash({:error, reason}, _pact_tx_hash), do: {:error, reason}

  @impl true
  def set_step(%__MODULE__{} = cmd_request, step) when is_integer(step),
    do: %{cmd_request | step: step}

  def set_step(%__MODULE__{}, _step), do: {:error, [step: :not_an_integer]}
  def set_step({:error, reason}, _step), do: {:error, reason}

  @impl true
  def set_proof(%__MODULE__{} = cmd_request, proof) when is_binary(proof),
    do: %{cmd_request | proof: proof}

  def set_proof(%__MODULE__{} = cmd_request, nil), do: cmd_request

  def set_proof(%__MODULE__{}, _proof), do: {:error, [proof: :not_a_string]}
  def set_proof({:error, reason}, _proof), do: {:error, reason}

  @impl true

  def set_rollback(%__MODULE__{} = cmd_request, rollback) when is_boolean(rollback),
    do: %{cmd_request | rollback: rollback}

  def set_rollback(%__MODULE__{}, _rollback), do: {:error, [rollback: :not_a_boolean]}
  def set_rollback({:error, reason}, _rollback), do: {:error, reason}

  @impl true
  def build(
        %__MODULE__{
          keypairs: keypairs
        } = cmd_request
      ) do
    with {:ok, payload} <- create_payload(cmd_request),
         {:ok, cmd} <- command_to_json_string(payload, cmd_request),
         {:ok, sig_commands} <- sign_commands([], cmd, keypairs),
         {:ok, hash} <- Hash.pull_unique(sig_commands),
         {:ok, signatures} <- build_signatures(sig_commands, []),
         {:ok, command} <- create_command(hash, signatures, cmd) do
      command
    end
  end

  def build(_module), do: {:error, [exec_command_request: :invalid_payload]}

  @spec set_signers_from_keypair(t(), keypair()) :: t()
  defp set_signers_from_keypair(cmd_request, %KeyPair{pub_key: pub_key, clist: clist}) do
    signer = Signer.new(pub_key: pub_key, clist: clist, scheme: :ed25519)
    add_signer(cmd_request, signer)
  end

  @spec create_payload(t()) :: valid_payload()
  defp create_payload(%__MODULE__{
         data: data,
         pact_tx_hash: pact_tx_hash,
         proof: proof,
         rollback: rollback,
         step: step
       }) do
    [data: data, pact_id: pact_tx_hash, proof: proof, rollback: rollback, step: step]
    |> ContPayload.new()
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

  @spec create_command(
          hash :: hash(),
          sigs :: signatures(),
          cmd :: cmd()
        ) :: valid_command()
  defp create_command(hash, sigs, cmd) do
    case Command.new(hash: hash, sigs: sigs, cmd: cmd) do
      %Command{} = command -> {:ok, command}
    end
  end

  @spec sign_commands(signs :: list(), cmd :: json_string_payload(), keypairs()) ::
          valid_sign_commands()
  defp sign_commands([], cmd, []) do
    cmd
    |> Utils.blake2b_hash(byte_size: 32)
    |> Utils.url_encode64()
    |> (&SignCommand.new(hash: &1)).()
    |> (&{:ok, [&1]}).()
  end

  defp sign_commands(signs, _cmd, []), do: {:ok, signs}

  defp sign_commands(signs, cmd, [%KeyPair{} = keypair | keypairs]) do
    signs
    |> sign_command(cmd, keypair)
    |> sign_commands(cmd, keypairs)
  end

  @spec sign_command(signs :: list(), cmd :: json_string_payload(), keypair()) ::
          list()
  defp sign_command(signs, cmd, %KeyPair{} = keypair) do
    {:ok, sign_command} = Sign.sign(cmd, keypair)
    signs ++ [sign_command]
  end

  @spec build_signatures(sign_commands :: sign_commands(), result :: list()) :: valid_signatures()
  defp build_signatures([], result), do: {:ok, SignaturesList.new(result)}

  defp build_signatures([%SignCommand{sig: sig} | rest], result),
    do: build_signatures(rest, result ++ [sig])
end
