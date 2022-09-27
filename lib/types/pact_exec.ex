defmodule Kadena.Types.PactExec do
  @moduledoc """
  `PactExec` struct definition.
  """

  alias Kadena.Types.{PactTransactionHash, Step}

  @behaviour Kadena.Types.Spec

  @type pact_id :: PactTransactionHash.t()
  @type step :: Step.t()
  @type step_count :: number()
  @type executed :: boolean() | nil
  @type step_has_rollback :: boolean()
  @type continuation :: map() | nil
  @type yield :: map() | nil
  @type validation :: {:ok, any()} | {:error, atom()}

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
         {:ok, executed} <- validate_executed(executed),
         {:ok, step_has_rollback} <- validate_step_has_rollback(step_has_rollback),
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

  @spec validate_pact_id(pact_id :: pact_id()) :: validation()
  defp validate_pact_id(%PactTransactionHash{} = pact_id), do: {:ok, pact_id}
  defp validate_pact_id(_pact_id), do: {:error, [pact_id: :invalid]}

  @spec validate_step(step :: step()) :: validation()
  defp validate_step(%Step{} = step), do: {:ok, step}
  defp validate_step(_step), do: {:error, [step: :invalid]}

  @spec validate_step_count(step_count :: step_count()) :: validation()
  defp validate_step_count(step_count) when is_number(step_count), do: {:ok, step_count}
  defp validate_step_count(_step_count), do: {:error, [step_count: :invalid]}

  @spec validate_executed(executed :: executed()) :: validation()
  defp validate_executed(executed) when is_boolean(executed), do: {:ok, executed}
  defp validate_executed(nil), do: {:ok, nil}
  defp validate_executed(_executed), do: {:error, [executed: :invalid]}

  @spec validate_step_has_rollback(step_has_rollback :: step_has_rollback()) :: validation()
  defp validate_step_has_rollback(step_has_rollback) when is_boolean(step_has_rollback),
    do: {:ok, step_has_rollback}

  defp validate_step_has_rollback(_step_has_rollback), do: {:error, [step_has_rollback: :invalid]}

  @spec validate_continuation(continuation :: continuation()) :: validation()
  defp validate_continuation(%{} = continuation), do: {:ok, continuation}
  defp validate_continuation(nil), do: {:ok, nil}
  defp validate_continuation(_continuation), do: {:error, [continuation: :invalid]}

  @spec validate_yield(yield :: yield()) :: validation()
  defp validate_yield(%{} = yield), do: {:ok, yield}
  defp validate_yield(nil), do: {:ok, nil}
  defp validate_yield(_yield), do: {:error, [yield: :invalid]}
end
