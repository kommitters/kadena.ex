defmodule Kadena.Chainweb.P2P.BlockHashRequestBody do
  @moduledoc """
  `BlockHashRequestBody` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type lower :: list(String.t())
  @type upper :: list(String.t())
  @type error :: {:error, Keyword.t()}
  @type args_validation :: {:ok, lower() | upper()} | error()

  @type t :: %__MODULE__{lower: lower(), upper: upper()}

  defstruct [:lower, :upper]

  @impl true
  def new(lower: lower, upper: upper) do
    with {:ok, lower} <- validate_args(lower),
         {:ok, upper} <- validate_args(upper) do
      %__MODULE__{lower: lower, upper: upper}
    end
  end

  @impl true
  def to_json!(%__MODULE__{lower: lower, upper: upper}),
    do: Jason.encode!(%{lower: lower, upper: upper})

  @spec validate_args(args :: list()) :: args_validation()
  defp validate_args(args) when is_list(args), do: {:ok, args}
  defp validate_args(_args), do: {:error, [args: :not_a_string_list]}
end
