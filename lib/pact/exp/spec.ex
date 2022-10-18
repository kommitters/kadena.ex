defmodule Kadena.Pact.Exp.Spec do
  @moduledoc """
  Specification for `Pact.Exp`.
  """

  @type exp :: String.t()
  @type args :: list()
  @type error :: Keyword.t()

  @callback create_exp(args()) :: {:ok, exp()} | {:error, error()}
end
