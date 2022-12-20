defmodule Kadena.Chainweb.Pact.Type do
  @moduledoc """
  Specifies the contracts to build the Chainweb types for Pact's endpoints.
  """

  @type attrs :: map() | struct() | Keyword.t() | list() | String.t()
  @type resource :: struct()
  @type error :: {:error, Keyword.t()}
  @type json :: String.t()

  @callback new(attrs()) :: resource() | error()
  @callback to_json!(resource()) :: json()

  @optional_callbacks to_json!: 1
end
