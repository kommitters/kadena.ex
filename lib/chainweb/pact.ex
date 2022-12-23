defmodule Kadena.Chainweb.Pact do
  @moduledoc """
  Exposes functions to interact with the Pact API endpoints.
  """

  alias Kadena.Chainweb.Pact.{Local, Poll, Send}

  @default_network_opts [network_id: :testnet04, chain_id: 0]

  defdelegate send(cmds, network_opts \\ @default_network_opts), to: Send, as: :process
  defdelegate local(cmds, network_opts \\ @default_network_opts), to: Local, as: :process
  defdelegate poll(cmds, network_opts \\ @default_network_opts), to: Poll, as: :process
end
