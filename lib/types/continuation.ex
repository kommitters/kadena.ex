defmodule Kadena.Types.Continuation do
  @moduledoc """
  `Continuation` struct definition.
  """

  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type def :: String.t()
  @type args :: PactValue.t()
  @type value :: def() | args()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          def: def(),
          args: args()
        }

  defstruct [:def, :args]

  @impl true
  def new(args) do
    def = Keyword.get(args, :def)
    args = Keyword.get(args, :args)

    with {:ok, def} <- validate_def(def),
         {:ok, args} <- validate_args(args) do
      %__MODULE__{def: def, args: args}
    end
  end

  @spec validate_def(def :: def()) :: validation()
  def validate_def(def) when is_binary(def), do: {:ok, def}
  def validate_def(_def), do: {:error, [def: :invalid]}

  @spec validate_args(args :: args()) :: validation()
  def validate_args(%PactValue{} = args), do: {:ok, args}

  def validate_args(args) do
    case PactValue.new(args) do
      %PactValue{} = args -> {:ok, args}
      _error -> {:error, [args: :invalid]}
    end
  end
end
