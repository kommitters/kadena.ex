defmodule Kadena.Chainweb.Pact.Spec do
  @moduledoc """
  Specification for `Chainweb.Pact` contracts.
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

  @type listen_request :: ListenRequestBody.t()
  @type local_request :: LocalRequestBody.t()
  @type poll_request :: PollRequestBody.t()
  @type send_request :: SendRequestBody.t()
  @type spv_request :: SPVRequestBody.t()

  @type listen_response :: ListenResponse.t()
  @type local_response :: LocalResponse.t()
  @type poll_response :: PollResponse.t()
  @type send_response :: SendResponse.t()
  @type spv_response :: SPVResponse.t()

  @type network :: :public | :test | nil
  @type chain_id :: String.t()
  @type error :: {:error, Keyword.t()}
  @type body :: String.t()
  @type request ::
          listen_request() | local_request() | poll_request() | send_request() | spv_request()
  @type response ::
          listen_response()
          | local_response()
          | poll_response()
          | send_response()
          | spv_response()

  @callback process(request :: request(), network :: network(), chain_id :: chain_id()) ::
              {:ok, response()} | error()
  @callback prepare(request :: request()) :: body() | error()
end
