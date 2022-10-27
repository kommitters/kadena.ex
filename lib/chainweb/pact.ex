defmodule Kadena.Chainweb.Pact do
  @moduledoc """
  Specifies the API for processing HTTP requests in the Kadena network.
  """

  alias Kadena.Chainweb.Pact.{Listen, Local, Poll, Send, SPV}

  # defdelegate listen(request, network, chain_id), to: Listen, as: :process
  # defdelegate local(request, network, chain_id), to: Local, as: :process
  # defdelegate poll(request, network, chain_id), to: Poll, as: :process
  defdelegate send(request, network, chain_id), to: Send, as: :process
  # defdelegate spv(request, network, chain_id), to: SPV, as: :process
end
