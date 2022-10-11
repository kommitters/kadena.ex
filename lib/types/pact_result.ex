defmodule Kadena.Types.PactResult do
  @moduledoc """
  `PactResult` struct definition.
  """

  alias Kadena.Types.PactValue

  @behaviour Kadena.Types.Spec

  @type status :: :success | :failure
  @type data :: PactValue.t()
  @type error :: map()
  @type result :: data() | error()
  @type value :: status() | result()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          status: status(),
          result: result()
        }

  defstruct [:status, :result]

  @impl true
  def new(args) do
    status = Keyword.get(args, :status)
    result = Keyword.get(args, :result)

    with {:ok, status} <- validate_status(status),
         {:ok, result} <- validate_result(status, result) do
      %__MODULE__{status: status, result: result}
    end
  end

  @spec validate_status(status :: status()) :: validation()
  def validate_status(status) when status in [:success, :failure], do: {:ok, status}
  def validate_status(_status), do: {:error, [status: :invalid]}

  @spec validate_result(status :: status(), result :: result()) :: validation()
  def validate_result(:failure, %{} = result), do: {:ok, result}
  def validate_result(:success, %PactValue{} = result), do: {:ok, result}

  def validate_result(:success, result) do
    case PactValue.new(result) do
      %PactValue{} = data -> {:ok, data}
      {:error, reason} -> {:error, [result: :invalid] ++ reason}
    end
  end

  def validate_result(_status, _result), do: {:error, [result: :invalid]}
end
