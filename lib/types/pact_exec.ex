defmodule Kadena.Types.PactExec do
  @moduledoc """
  `PactExec` struct definition.
  """

  alias Kadena.Types.{Continuation, PactTransactionHash, Step, Yield}

  @behaviour Kadena.Types.Spec

  @type pact_id :: PactTransactionHash.t()
  @type pact_id_arg :: String.t()
  @type step :: Step.t()
  @type step_arg :: number()
  @type step_count :: integer()
  @type executed :: boolean() | nil
  @type step_has_rollback :: boolean()
  @type continuation :: Continuation.t()
  @type yield :: Yield.t() | nil
  @type bool_value :: executed() | step_has_rollback()
  @type value :: pact_id() | step() | step_count() | bool_value() | continuation() | yield()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          pact_id: pact_id(),
          step: step(),
          step_count: step_count(),
          executed: executed(),
          step_has_rollback: step_has_rollback(),
          continuation: continuation(),
          yield: yield()
        }

  defstruct [:pact_id, :step, :step_count, :executed, :step_has_rollback, :continuation, :yield]

  @impl true
  def new(args) do
    pact_id = Keyword.get(args, :pact_id)
    step = Keyword.get(args, :step)
    step_count = Keyword.get(args, :step_count)
    executed = Keyword.get(args, :executed)
    step_has_rollback = Keyword.get(args, :step_has_rollback)
    continuation = Keyword.get(args, :continuation)
    yield = Keyword.get(args, :yield)

    with {:ok, pact_id} <- validate_pact_id(pact_id),
         {:ok, step} <- validate_step(step),
         {:ok, step_count} <- validate_step_count(step_count),
         {:ok, executed} <- validate_boolean(:executed, executed),
         {:ok, step_has_rollback} <- validate_boolean(:step_has_rollback, step_has_rollback),
         {:ok, continuation} <- validate_continuation(continuation),
         {:ok, yield} <- validate_yield(yield) do
      %__MODULE__{
        pact_id: pact_id,
        step: step,
        step_count: step_count,
        executed: executed,
        step_has_rollback: step_has_rollback,
        continuation: continuation,
        yield: yield
      }
    end
  end

  @spec validate_pact_id(pact_id :: pact_id_arg()) :: validation()
  defp validate_pact_id(pact_id) do
    case PactTransactionHash.new(pact_id) do
      %PactTransactionHash{} = pact_hash -> {:ok, pact_hash}
      _error -> {:error, [pact_id: :invalid]}
    end
  end

  @spec validate_step(step :: step_arg()) :: validation()
  defp validate_step(step) do
    case Step.new(step) do
      %Step{} = step -> {:ok, step}
      _error -> {:error, [step: :invalid]}
    end
  end

  @spec validate_step_count(step_count :: step_count()) :: validation()
  defp validate_step_count(step_count) when is_integer(step_count), do: {:ok, step_count}
  defp validate_step_count(_step_count), do: {:error, [step_count: :invalid]}

  @spec validate_boolean(field :: atom(), value :: bool_value()) :: validation()
  defp validate_boolean(_field, value) when is_boolean(value), do: {:ok, value}
  defp validate_boolean(:executed, nil), do: {:ok, nil}
  defp validate_boolean(field, _value), do: {:error, [{field, :invalid}]}

  @spec validate_continuation(continuation :: continuation()) :: validation()
  defp validate_continuation(%Continuation{} = continuation), do: {:ok, continuation}

  defp validate_continuation(continuation) when is_list(continuation) do
    case Continuation.new(continuation) do
      %Continuation{} = continuation -> {:ok, continuation}
      {:error, reason} -> {:error, [continuation: :invalid] ++ reason}
    end
  end

  defp validate_continuation(_continuation), do: {:error, [continuation: :invalid]}

  @spec validate_yield(yield :: yield()) :: validation()
  defp validate_yield(nil), do: {:ok, nil}
  defp validate_yield(%Yield{} = yield), do: {:ok, yield}

  defp validate_yield(yield) when is_list(yield) do
    case Yield.new(yield) do
      %Yield{} = yield -> {:ok, yield}
      {:error, reason} -> {:error, [yield: :invalid] ++ reason}
    end
  end

  defp validate_yield(_yield), do: {:error, [yield: :invalid]}
end
