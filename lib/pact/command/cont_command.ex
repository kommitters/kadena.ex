defmodule Kadena.Pact.ContCommand do
  @moduledoc """
  Specifies functions to build PACT continuation command requests.
  """

  alias Kadena.Chainweb.Pact.JSONPayload
  alias Kadena.Cryptography.Sign
  alias Kadena.Pact.Command

  alias Kadena.Types.{
    Command,
    CommandPayload,
    ContPayload,
    EnvData,
    KeyPair,
    MetaData,
    NetworkID,
    PactPayload,
    PactTransactionHash,
    Proof,
    Rollback,
    SignaturesList,
    SignCommand,
    Signer,
    SignersList,
    Step
  }

  @behaviour Kadena.Pact.Command

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
  @type pact_tx_hash :: PactTransactionHash.t()
  @type proof :: Proof.t() | nil
  @type rollback :: Rollback.t()
  @type signer :: Signer.t()
  @type signers :: SignersList.t()
  @type signatures :: SignaturesList.t()
  @type sign_command :: SignCommand.t()
  @type sign_commands :: list(sign_command())
  @type step :: Step.t()
  @type valid_command :: {:ok, command()}
  @type valid_command_json_string :: {:ok, json_string_payload()}
  @type valid_hash :: {:ok, hash()}
  @type valid_payload :: {:ok, pact_payload()}
  @type valid_sign_command :: {:ok, [sign_command()]}
  @type valid_sign_commands :: {:ok, [sign_command()]}
  @type valid_signatures :: {:ok, signatures()}

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
    :signers,
    keypairs: []
  ]

  @impl true
  def new(opts \\ nil)

  def new(opts) when is_list(opts) do
    network_id = Keyword.get(opts, :network_id)
    data = Keyword.get(opts, :data)
    nonce = Keyword.get(opts, :nonce, "")
    meta_data = Keyword.get(opts, :meta_data, %MetaData{})
    pact_tx_hash = Keyword.get(opts, :pact_tx_hash, "")
    step = Keyword.get(opts, :step, %Step{})
    proof = Keyword.get(opts, :proof)
    rollback = Keyword.get(opts, :rollback, %Rollback{})
    keypairs = Keyword.get(opts, :keypairs, [])
    signers = Keyword.get(opts, :signers, %SignersList{})

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

  def set_metadata(%__MODULE__{} = cmd_request, meta_data) do
    case MetaData.new(meta_data) do
      %MetaData{} = meta_data -> %{cmd_request | meta_data: meta_data}
      {:error, reason} -> {:error, [meta_data: :invalid] ++ reason}
    end
  end

  def set_metadata({:error, reason}, _metadata), do: {:error, reason}

  @impl true
  def add_keypair(%__MODULE__{keypairs: keypairs} = cmd_request, %KeyPair{} = keypair),
    do: %{cmd_request | keypairs: keypairs ++ [keypair]}

  def add_keypair(%__MODULE__{} = cmd_request, keypair) do
    case KeyPair.new(keypair) do
      %KeyPair{} = keypair -> add_keypair(cmd_request, keypair)
      {:error, reason} -> {:error, [keypair: :invalid] ++ reason}
    end
  end

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

  def add_signers(%__MODULE__{} = cmd_request, signers) do
    case SignersList.new(signers) do
      %SignersList{} = signers -> %{cmd_request | signers: signers}
      {:error, reason} -> {:error, [signers: :invalid] ++ reason}
    end
  end

  def add_signers({:error, reason}, _signers), do: {:error, reason}

  @impl true
  def set_pact_tx_hash(%__MODULE__{} = cmd_request, pact_tx_hash) when is_binary(pact_tx_hash) do
    %{cmd_request | pact_tx_hash: pact_tx_hash}
  end

  def set_pact_tx_hash(%__MODULE__{}, _pact_tx_hash), do: {:error, [pact_tx_hash: :not_a_string]}
  def set_pact_tx_hash({:error, reason}, _pact_tx_hash), do: {:error, reason}

  @impl true
  def set_step(%__MODULE__{} = cmd_request, step) when is_integer(step) do
    %{cmd_request | step: step}
  end

  def set_step(%__MODULE__{}, _step), do: {:error, [step: :not_an_integer]}
  def set_step({:error, reason}, _step), do: {:error, reason}

  @impl true
  def set_proof(%__MODULE__{} = cmd_request, proof) when is_binary(proof) do
    %{cmd_request | proof: proof}
  end

  def set_proof(%__MODULE__{}, _proof), do: {:error, [proof: :not_a_string]}
  def set_proof({:error, reason}, _proof), do: {:error, reason}

  @impl true

  def set_rollback(%__MODULE__{} = cmd_request, rollback) when is_boolean(rollback) do
    %{cmd_request | rollback: rollback}
  end

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
         {:ok, hash} <- get_unique_hash(sig_commands),
         {:ok, signatures} <- build_signatures(sig_commands, []),
         {:ok, command} <- create_command(hash, signatures, cmd) do
      %Command{} = command
    end
  end

  def build(_module), do: {:error, [exec_command_request: :invalid_payload]}

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

  @spec sign_commands(signs :: list(), cmd :: json_string_payload(), keypairs()) ::
          valid_sign_commands()
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

  @spec get_unique_hash(sign_commands()) :: valid_hash()
  defp get_unique_hash(sign_commands) do
    unique_hash =
      Enum.reduce(sign_commands, nil, fn %SignCommand{hash: hash}, acc ->
        if is_nil(acc) or acc == hash,
          do: hash,
          else: {:error, [hash: :hashes_are_not_unique]}
      end)

    {:ok, unique_hash}
  end
end
