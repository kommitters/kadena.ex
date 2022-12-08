defmodule Kadena.Types.CommandPayload do
  @moduledoc """
  `CommandPayload` struct definition.
  """

  alias Kadena.Types.{MetaData, NetworkID, PactPayload, SignersList}

  @behaviour Kadena.Types.Spec

  @type network_id :: NetworkID.t() | nil
  @type payload :: PactPayload.t()
  @type signers :: SignersList.t()
  @type meta :: MetaData.t()
  @type nonce :: String.t()
  @type value :: network_id() | payload() | signers() | meta() | nonce()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}
  @type t :: %__MODULE__{
          network_id: network_id(),
          payload: payload(),
          signers: signers(),
          meta: meta(),
          nonce: nonce()
        }

  defstruct [:network_id, :payload, :signers, :meta, :nonce]

  @impl true
  def new(args) do
    network_id = Keyword.get(args, :network_id)
    payload = Keyword.get(args, :payload)
    signers = Keyword.get(args, :signers, [])
    meta = Keyword.get(args, :meta)
    nonce = Keyword.get(args, :nonce)

    with {:ok, network_id} <- validate_network_id(network_id),
         {:ok, payload} <- validate_payload(payload),
         {:ok, signers} <- validate_signers(signers),
         {:ok, meta} <- validate_meta(meta),
         {:ok, nonce} <- validate_nonce(nonce) do
      %__MODULE__{
        network_id: network_id,
        payload: payload,
        signers: signers,
        meta: meta,
        nonce: nonce
      }
    end
  end

  @spec validate_network_id(network_id :: network_id()) :: validation()
  defp validate_network_id(%NetworkID{} = network_id), do: {:ok, network_id}

  defp validate_network_id(network_id) do
    case NetworkID.new(network_id) do
      %NetworkID{} = network_id -> {:ok, network_id}
      _error -> {:error, [network_id: :invalid]}
    end
  end

  @spec validate_payload(payload :: payload()) :: validation()
  defp validate_payload(%PactPayload{} = payload), do: {:ok, payload}

  defp validate_payload(payload) do
    case PactPayload.new(payload) do
      %PactPayload{} = payload -> {:ok, payload}
      _error -> {:error, [payload: :invalid]}
    end
  end

  @spec validate_signers(signers :: signers()) :: validation()
  defp validate_signers(%SignersList{} = signers), do: {:ok, signers}

  defp validate_signers(signers) do
    case SignersList.new(signers) do
      %SignersList{} = signers -> {:ok, signers}
      _error -> {:error, [signers: :invalid]}
    end
  end

  @spec validate_meta(meta :: meta()) :: validation()
  defp validate_meta(%MetaData{} = meta), do: {:ok, meta}
  defp validate_meta(meta) when is_nil(meta), do: {:ok, %MetaData{}}

  defp validate_meta(meta) do
    case MetaData.new(meta) do
      %MetaData{} = meta -> {:ok, meta}
      {:error, _reason} -> {:error, [meta: :invalid]}
    end
  end

  @spec validate_nonce(nonce :: nonce()) :: validation()
  defp validate_nonce(nonce) when is_binary(nonce), do: {:ok, nonce}
  defp validate_nonce(nonce) when is_nil(nonce), do: {:ok, ""}
  defp validate_nonce(_nonce), do: {:error, [nonce: :not_a_string]}

  defimpl Kadena.Chainweb.Pact.JSONPayload do
    alias Kadena.Utils.MapCase

    alias Kadena.Types.{
      Base16String,
      Cap,
      CapsList,
      ChainID,
      CommandPayload,
      ContPayload,
      EnvData,
      ExecPayload,
      OptionalCapsList,
      PactCode,
      PactDecimal,
      PactInt,
      PactTransactionHash,
      PactValue,
      PactValuesList,
      Proof,
      Rollback,
      Signer,
      Step
    }

    @type json :: String.t()
    @type signers_list :: SignersList.t()
    @type signers :: list(map())
    @type network_id :: NetworkID.t()
    @type string_value :: String.t() | nil
    @type pact_payload :: PactPayload.t()
    @type proof :: Proof.t() | nil
    @type data :: EnvData.t() | nil
    @type meta :: MetaData.t()
    @type signer :: Signer.t()
    @type addr :: Base16String.t() | nil
    @type scheme :: :ed25519 | nil
    @type valid_scheme :: :ED25519 | nil
    @type clist :: CapsList.t() | nil
    @type valid_clist :: list(map())
    @type cap :: Cap.t()
    @type pact_values_list :: PactValuesList.t()
    @type literal ::
            integer()
            | boolean()
            | String.t()
            | PactInt.t()
            | PactDecimal.t()
            | PactValuesList.t()
    @type value :: integer() | string_value() | boolean() | Decimal.t()
    @type valid_pact_value :: list(value)
    @type pact_value :: list(valid_pact_value())
    @type map_return :: map() | nil
    @type valid_extract :: {:ok, string_value()} | {:ok, map_return()} | {:ok, signers()}

    @impl true
    def parse(%CommandPayload{
          network_id: network_id,
          payload: payload,
          signers: signers,
          meta: meta,
          nonce: nonce
        }) do
      with {:ok, payload} <- extract_payload(payload),
           {:ok, meta} <- extract_meta(meta),
           {:ok, network_id} <- extract_network_id(network_id),
           {:ok, signers} <- extract_signers_list(signers) do
        %{
          payload: payload,
          meta: meta,
          network_id: network_id,
          nonce: nonce,
          signers: signers
        }
        |> MapCase.to_camel!()
        |> Jason.encode!()
      end
    end

    @spec extract_network_id(network_id()) :: valid_extract()
    defp extract_network_id(%NetworkID{id: id}), do: {:ok, id}

    @spec extract_payload(pact_payload()) :: valid_extract()
    defp extract_payload(%PactPayload{payload: %ExecPayload{} = exec_payload}) do
      %ExecPayload{code: %PactCode{code: code}, data: data} = exec_payload
      payload = %{exec: %{code: code, data: extract_data(data)}}
      {:ok, payload}
    end

    defp extract_payload(%PactPayload{
           payload: %ContPayload{
             data: data,
             pact_id: %PactTransactionHash{hash: hash},
             proof: proof,
             rollback: %Rollback{value: rollback},
             step: %Step{number: number}
           }
         }) do
      payload = %{
        cont: %{
          data: extract_data(data),
          pact_id: hash,
          proof: extract_proof(proof),
          rollback: rollback,
          step: number
        }
      }

      {:ok, payload}
    end

    @spec extract_proof(proof()) :: string_value()
    defp extract_proof(nil), do: nil
    defp extract_proof(%Proof{value: proof}), do: proof

    @spec extract_data(data()) :: map_return()
    defp extract_data(nil), do: nil
    defp extract_data(%EnvData{data: data}), do: data

    @spec extract_meta(meta()) :: valid_extract()
    defp extract_meta(%MetaData{
           creation_time: creation_time,
           ttl: ttl,
           gas_limit: gas_limit,
           gas_price: gas_price,
           sender: sender,
           chain_id: %ChainID{id: id}
         }) do
      meta = %{
        chain_id: id,
        creation_time: creation_time,
        gas_limit: gas_limit,
        gas_price: gas_price,
        sender: sender,
        ttl: ttl
      }

      {:ok, meta}
    end

    @spec extract_signers_list(signers :: signers_list()) :: valid_extract()
    defp extract_signers_list(%SignersList{signers: list}) do
      signers = Enum.map(list, fn sig -> extract_signer_info(sig) end)
      {:ok, signers}
    end

    @spec extract_signer_info(signer()) :: map_return()
    defp extract_signer_info(%Signer{
           addr: addr,
           scheme: scheme,
           pub_key: %Base16String{value: pub_key},
           clist: %OptionalCapsList{clist: clist}
         }) do
      %{
        addr: extract_addr(addr),
        scheme: extract_scheme(scheme),
        pub_key: pub_key,
        clist: extract_clist(clist)
      }
    end

    @spec extract_addr(addr()) :: string_value()
    defp extract_addr(nil), do: nil
    defp extract_addr(%Base16String{value: value}), do: value

    @spec extract_scheme(scheme()) :: valid_scheme()
    defp extract_scheme(nil), do: nil
    defp extract_scheme(:ed25519), do: :ED25519

    @spec extract_clist(clist()) :: valid_clist()
    defp extract_clist(nil), do: []

    defp extract_clist(%CapsList{caps: caps}) do
      Enum.map(caps, fn cap -> extract_cap_info(cap) end)
    end

    @spec extract_cap_info(cap()) :: map_return()
    defp extract_cap_info(%Cap{name: name, args: args}) do
      %{name: name, args: extract_values(args)}
    end

    @spec extract_values(pact_values_list()) :: pact_value()
    defp extract_values(%PactValuesList{pact_values: pact_values}) do
      Enum.map(pact_values, fn %PactValue{literal: pact_value} -> extract_value(pact_value) end)
    end

    @spec extract_value(literal()) :: valid_pact_value()
    defp extract_value(%PactValuesList{} = pact_value), do: extract_values(pact_value)
    defp extract_value(%PactInt{raw_value: value}), do: value
    defp extract_value(%PactDecimal{raw_value: value}), do: value
    defp extract_value(value), do: value
  end
end
