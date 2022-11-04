defprotocol Kadena.Chainweb.Pact.JSONRequestBody do
  alias Kadena.Types.{
    ListenRequestBody,
    LocalRequestBody,
    PollRequestBody,
    SendRequestBody,
    SPVRequestBody
  }

  @type json_string :: String.t()
  @type request_body ::
          ListenRequestBody.t()
          | LocalRequestBody.t()
          | PollRequestBody.t()
          | SendRequestBody.t()
          | SPVRequestBody.t()

  @spec parse(request_body :: request_body()) :: json_string()
  def parse(request_body)
end
