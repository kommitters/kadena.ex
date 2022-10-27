defmodule Kadena.Pact do
  @moduledoc """
    Module to access to pact functions for users
  """
  alias Kadena.Pact.{Exp, Number}
  # Exp functions
  defdelegate create_exp(args), to: Exp, as: :create
  # Number functions
  defdelegate to_pact_integer(str), to: Number
  defdelegate to_pact_decimal(str), to: Number
  defdelegate to_json_string(args), to: Number
end
