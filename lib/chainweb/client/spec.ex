defmodule Kadena.Chainweb.Client.Spec do
  @moduledoc """
  Specifies expected behaviour of an HTTP client.

  Kadena allows you to use your HTTP client of choice, provided that it can be coerced into complying with this module's specification.
  The default is :hackney.
  """

  @type method :: :get | :post | :put | :delete
  @type headers :: [{binary(), binary()}, ...]
  @type chain_id :: String.t()
  @type body :: binary()
  @type status :: non_neg_integer()
  @type options :: Keyword.t()
  @type response :: {:ok, status(), headers()}
  @type response_with_body :: {:ok, status(), headers(), body()}
  @type response_error :: {:error, Keyword.t()}

  @callback request(
              method :: method(),
              url :: binary(),
              chain_id :: chain_id(),
              body :: binary(),
              headers :: headers(),
              options :: options()
            ) :: response() | response_with_body() | response_error()
end
