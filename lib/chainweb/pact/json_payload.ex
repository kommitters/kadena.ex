defprotocol Kadena.Chainweb.Pact.JSONPayload do
  alias Kadena.Chainweb.Pact.{
    CommandPayload,
    ListenRequestBody,
    LocalRequestBody,
    PollRequestBody,
    SendRequestBody,
    SPVRequestBody
  }

  @type json_string :: String.t()
  @type request_body ::
          CommandPayload.t()
          | ListenRequestBody.t()
          | LocalRequestBody.t()
          | PollRequestBody.t()
          | SendRequestBody.t()
          | SPVRequestBody.t()

  @spec parse(request_body :: request_body()) :: json_string()
  def parse(request_body)
end
