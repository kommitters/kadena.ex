defmodule Kadena.Chainweb.P2P.BlockBranchesBoundsRequestBody do
  @moduledoc """
  `BlockBranchesBoundsRequestBody` struct definition.
  """

  @behaviour Kadena.Chainweb.Type

  @type error :: {:error, Keyword.t()}
  @type args_validation :: {:ok, list(String.t())} | error()

  @type t :: %__MODULE__{lower: list(String.t()), upper: list(String.t())}

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

  @spec validate_args(args :: list(String.t())) :: args_validation()
  defp validate_args(args) when is_list(args), do: {:ok, args}
  defp validate_args(_args), do: {:error, [args: :not_a_string_list]}
end
