defmodule Kadena.Types.CommandPayload do
  @moduledoc """

  """
  alias Kadena.Types.NetworkID

  @behaviour Kadena.Types.Spec

  # @type network_id :: NetworkID.t() | nil
  # @type payload :: PactPayload.t()
  # @type t :: %__MODULE__{
  #   network_id: network_id(),
  #   payload: payload(),
  #   signers: list(Signer.t()),
  #   meta: MetaData.t(),
  #   nonce: String.t()
  # }

  # defstruct [:network_id, :payload, :signers, :meta, :nonce]

  @impl true
  def new(_args) do
  end
end
