defmodule Kadena.Types.Continuation do
  @moduledoc """
  `Continuation` struct definition.
  """

  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type continuation_def :: String.t()
  @type args :: PactValue.t()
  @type value :: continuation_def() | args()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          def: continuation_def(),
          args: args()
        }

  defstruct [:def, :args]

  @impl true
  def new(args) do
    continuation_def = Keyword.get(args, :def)
    args = Keyword.get(args, :args)

    with {:ok, continuation_def} <- validate_def(continuation_def),
         {:ok, args} <- validate_args(args) do
      %__MODULE__{def: continuation_def, args: args}
    end
  end

  @spec validate_def(continuation_def :: continuation_def()) :: validation()
  def validate_def(continuation_def) when is_binary(continuation_def), do: {:ok, continuation_def}
  def validate_def(_continuation_def), do: {:error, [def: :invalid]}

  @spec validate_args(args :: args()) :: validation()
  def validate_args(%PactValue{} = args), do: {:ok, args}

  def validate_args(args) do
    case PactValue.new(args) do
      %PactValue{} = args -> {:ok, args}
      _error -> {:error, [args: :invalid]}
    end
  end
end
