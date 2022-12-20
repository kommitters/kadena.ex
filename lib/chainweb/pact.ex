defmodule Kadena.Chainweb.Pact do
  @moduledoc """
  Exposes functions to interact with the Pact API endpoints.
  """

  alias Kadena.Chainweb.Pact.Send

  @default_network_opts [network_id: :testnet04, chain_id: 0]

  defdelegate send(cmds, network_opts \\ @default_network_opts), to: Send, as: :process
end
