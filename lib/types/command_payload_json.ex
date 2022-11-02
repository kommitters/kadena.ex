defmodule Kadena.Types.CommandPayloadJSON do
  @moduledoc """
  `CommandPayloadJSON` struct definition.
  """

  alias Kadena.Types.{
    Base16String,
    Cap,
    CapsList,
    ChainID,
    CommandPayload,
    ContPayload,
    EnvData,
    ExecPayload,
    MetaData,
    NetworkID,
    OptionalCapsList,
    PactCode,
    PactDecimal,
    PactInt,
    PactPayload,
    PactTransactionHash,
    PactValue,
    PactValuesList,
    Proof,
    Rollback,
    Signer,
    SignersList,
    Step
  }

  @behaviour Kadena.Types.Spec

  @type json :: String.t()
  @type signers_list :: SignersList.t()
  @type signers :: list(map())
  @type network_id :: NetworkID.t()
  @type str :: String.t()
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
  @type value :: integer() | str() | boolean() | Decimal.t()
  @type valid_pact_value :: list(value)
  @type pact_value :: list(valid_pact_value())

  @type t :: %__MODULE__{json: json()}

  defstruct [:json]

  @impl true
  def new(%CommandPayload{
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
      request_body =
        %{
          payload: payload,
          meta: meta,
          network_id: network_id,
          nonce: nonce,
          signers: signers
        }
        |> Casex.to_camel_case()
        |> Jason.encode!()

      %__MODULE__{json: request_body}
    end
  end

  @spec extract_network_id(network_id()) :: {:ok, str()}
  defp extract_network_id(%NetworkID{id: id}), do: {:ok, id}

  @spec extract_payload(pact_payload()) :: {:ok, map()}
  defp extract_payload(%PactPayload{payload: %ExecPayload{} = exec_payload}) do
    %ExecPayload{code: %PactCode{code: code}, data: data} = exec_payload
    payload = %{exec: %{code: code, data: validate_data(data)}}
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
        data: validate_data(data),
        pact_id: hash,
        proof: validate_proof(proof),
        roollback: rollback,
        step: number
      }
    }

    {:ok, payload}
  end

  @spec validate_proof(proof()) :: str() | nil
  defp validate_proof(nil), do: nil
  defp validate_proof(%Proof{value: proof}), do: proof

  @spec validate_data(data()) :: map() | nil
  defp validate_data(nil), do: nil
  defp validate_data(%EnvData{data: data}), do: data

  @spec extract_meta(meta()) :: {:ok, map()}
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

  @spec extract_signers_list(signers :: signers_list()) :: {:ok, signers()}
  defp extract_signers_list(%SignersList{signers: list}) do
    signers = Enum.map(list, fn sig -> extract_signer_info(sig) end)
    {:ok, signers}
  end

  @spec extract_signer_info(signer()) :: map()
  defp extract_signer_info(%Signer{
         addr: addr,
         scheme: scheme,
         pub_key: %Base16String{value: pub_key},
         clist: %OptionalCapsList{clist: clist}
       }) do
    %{
      addr: validate_addr(addr),
      scheme: validate_scheme(scheme),
      pub_key: pub_key,
      clist: validate_clist(clist)
    }
  end

  @spec validate_addr(addr()) :: str() | nil
  defp validate_addr(nil), do: nil
  defp validate_addr(%Base16String{value: value}), do: value

  @spec validate_scheme(scheme()) :: valid_scheme()
  defp validate_scheme(nil), do: nil
  defp validate_scheme(:ed25519), do: :ED25519

  @spec validate_clist(clist()) :: valid_clist()
  defp validate_clist(nil), do: []

  defp validate_clist(%CapsList{caps: caps}) do
    Enum.map(caps, fn cap -> extract_cap_info(cap) end)
  end

  @spec extract_cap_info(cap()) :: map()
  defp extract_cap_info(%Cap{name: name, args: args}) do
    %{name: name, args: extract_values(args)}
  end

  @spec extract_values(pact_values_list()) :: pact_value()
  defp extract_values(%PactValuesList{pact_values: pact_values}) do
    Enum.map(pact_values, fn %PactValue{literal: pact_value} -> validate_value(pact_value) end)
  end

  @spec validate_value(literal()) :: valid_pact_value()
  defp validate_value(%PactValuesList{} = pact_value), do: extract_values(pact_value)
  defp validate_value(%PactInt{raw_value: value}), do: value
  defp validate_value(%PactDecimal{raw_value: value}), do: value
  defp validate_value(value), do: value
end
