defmodule Kadena.Chainweb.Pact.Spec do
  @moduledoc """
  Specifies the contracts to build the Pact's endpoints.
  """

  alias Kadena.Chainweb.Pact.{
    ListenResponse,
    LocalResponse,
    PollResponse,
    SendResponse,
    SPVResponse
  }

  alias Kadena.Chainweb.Error
  alias Kadena.Types.Command

  @type data :: list(Command.t()) | Command.t() | list(String.t()) | String.t() | list()
  @type error :: {:error, Error.t()}
  @type chain_id :: 0..19 | String.t()
  @type network_opts :: [network_id: atom(), chain_id: chain_id()]
  @type response ::
          ListenResponse.t()
          | LocalResponse.t()
          | PollResponse.t()
          | SendResponse.t()
          | SPVResponse.t()

  @callback process(data :: data(), network_opts :: network_opts()) :: {:ok, response()} | error()
end
