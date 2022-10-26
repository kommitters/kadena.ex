defmodule Kadena.Chainweb.Pact.Request do
  @moduledoc """
  Requests specification for `Chainweb.Pact` contracts.
  """

  alias Kadena.Types.{
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

  @type network :: :public | :test
  @type chain_id :: String.t()
  @type error :: {:error, Keyword.t()}
  @type body :: String.t()
  @type request ::
          ListenRequestBody.t()
          | LocalRequestBody.t()
          | PollRequestBody.t()
          | SendRequestBody.t()
          | SPVRequestBody.t()
  @type response ::
          ListenResponse.t()
          | LocalResponse.t()
          | PollResponse.t()
          | SendResponse.t()
          | SPVResponse.t()

  @callback process(request :: request(), network :: network(), chain_id :: chain_id()) ::
              {:ok, response()} | error()
  @callback prepare(request :: request()) :: body() | error()
end
