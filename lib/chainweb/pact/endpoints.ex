defmodule Kadena.Chainweb.Pact.Endpoints do
  @moduledoc """
  Requests specification for `Chainweb.Pact` contracts.
  """

<<<<<<< HEAD:lib/chainweb/pact/request.ex
=======
  alias Kadena.Types.Command
  alias Kadena.Types.CommandsList

  alias Kadena.Types.{
    Command,
    CommandsList
  }

>>>>>>> 4e12645 (Add local endpoitn and PACT API):lib/chainweb/pact/endpoints.ex
  alias Kadena.Chainweb.Pact.{
    ListenRequestBody,
    ListenResponse,
    LocalRequestBody,
    LocalResponse,
    PollRequestBody,
    PollResponse,
    SendRequestBody,
    SendResponse,
    SPVRequestBody,
    SPVResponse
  }

  @type network :: atom()
  @type chain_id :: String.t()
  @type error :: {:error, Keyword.t()}
  @type body :: String.t()
  @type request ::
          Command.t()
          | CommandsList.t()
  @type response ::
          ListenResponse.t()
          | LocalResponse.t()
          | PollResponse.t()
          | SendResponse.t()
          | SPVResponse.t()

  @callback process(request :: request(), network :: network(), chain_id :: chain_id()) ::
              {:ok, response()} | error()
end
