defmodule Kadena.Pact.Exp do
  @moduledoc """
  Implementation for `Pact.Exp` functions.
  """

  @type args :: list()
  @type error :: {:error, Keyword.t()}
  @type result :: String.t()
  @type response :: {:ok, result()} | error()

  @spec create(args :: args()) :: response()
  def create(args) when is_list(args) do
    result = Enum.join(args, " ")

    {:ok, "(#{result})"}
  end

  def create(_args), do: {:error, [args: :not_a_list]}
end
