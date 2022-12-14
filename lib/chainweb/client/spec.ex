defmodule Kadena.Chainweb.Client.Spec do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.

  Kadena allows you to use your HTTP client of choice, provided that it can be coerced into complying with this module's specification.
  The default is :hackney.
  """

  alias Kadena.Chainweb.Error

  @type method :: :get | :post | :put | :delete
  @type headers :: [{binary(), binary()}, ...]
  @type body :: binary()
  @type status :: non_neg_integer()
  @type options :: Keyword.t()
  @type response :: {:ok, map()}
  @type response_error :: {:error, Error.t()}

  @callback request(
              method :: method(),
              url :: binary(),
              headers :: headers(),
              body :: binary(),
              options :: options()
            ) :: response() | response_error()
end
