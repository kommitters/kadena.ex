defmodule Kadena.Chainweb.Pact do
  @moduledoc """
<<<<<<< HEAD
  Exposes functions to interact with the Pact API endpoints.
  """

  alias Kadena.Chainweb.Pact.Send

  @default_network_opts [network_id: :testnet04, chain_id: 0]

  defdelegate send(cmds, network_opts \\ @default_network_opts), to: Send, as: :process
=======
  Specifies the API for processing HTTP requests.
  """

  alias Kadena.Chainweb.Pact.Local
  defdelegate local(request, network \\ :testnet04, chain_id \\ "0"), to: Local, as: :process

  # defdelegate send(request, network \\ :test, chain_id \\ "0"), to: Send, as: :process
  # defdelegate poll(request, network \\ :test, chain_id \\ "0"), to: Poll, as: :process
  # defdelegate listen(request, network \\ :test, chain_id \\ "0"), to: Listen, as: :process
  # defdelegate spv(request, network \\ :test, chain_id \\ "0"), to: SPV, as: :process
>>>>>>> 40795f4 (Add local endpoitn and PACT API)
end
