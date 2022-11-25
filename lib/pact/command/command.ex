defmodule Kadena.Pact.Command do
  @moduledoc """
  Specifies contracts to build PACT command requests.
  """

  alias Kadena.Pact.ExecCommand
  alias Kadena.Types.{ChainID, Command, KeyPair, MetaData, NetworkID, Signer, SignersList}

  @type cmd :: Command.t()
  @type network_id :: NetworkID.t()
  @type chain_id :: ChainID.t()
  @type cont_request :: struct()
  @type exec_request :: ExecCommand.t()
  @type cmd_request :: cont_request() | exec_request()

  @type string_value :: String.t()
  @type meta_data :: MetaData.t()
  @type keypair :: KeyPair.t()
  @type keypairs_list :: list(keypair())
  @type signer :: Signer.t()
  @type signers_list :: list(signer()) | SignersList.t()
  @type hash :: String.t()

  @callback new() :: cmd_request()
  @callback set_network(cmd :: cmd_request(), network :: atom()) :: cmd_request()
  @callback set_data(cmd :: cmd_request(), data :: map()) :: cmd_request()
  @callback set_nonce(cmd :: cmd_request(), nonce :: string_value()) :: cmd_request()
  @callback set_metadata(cmd :: cmd_request(), meta_data :: meta_data()) :: cmd_request()
  @callback add_keypair(cmd :: cmd_request(), keypair :: keypair()) :: cmd_request()
  @callback add_keypairs(cmd :: cmd_request(), keypairs :: keypairs_list()) :: cmd_request()
  @callback add_signer(cmd :: cmd_request(), signer :: signer()) :: cmd_request()
  @callback add_signers(cmd :: cmd_request(), signers :: signers_list()) :: cmd_request()
  @callback set_code(cmd :: exec_request(), code :: string_value()) :: exec_request()
  @callback set_pact_tx_hash(cmd :: cont_request(), hash :: hash()) :: cont_request()
  @callback set_step(cmd :: cont_request(), step :: integer()) :: cont_request()
  @callback set_proof(cmd :: cont_request(), proof :: string_value()) :: cont_request()
  @callback set_rollback(cmd :: cont_request(), rollback :: boolean()) :: cont_request()
  @callback build(cmd :: cmd_request()) :: cmd()

  @optional_callbacks set_code: 2,
                      set_pact_tx_hash: 2,
                      set_step: 2,
                      set_proof: 2,
                      set_rollback: 2
end
