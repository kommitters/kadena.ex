defmodule Kadena.Chainweb.Pact.Resources.PactExec do
  @moduledoc """
  `PactExec` struct definition.
  """

  alias Kadena.Chainweb.Mapping

  alias Kadena.Chainweb.Pact.Resources.{
    Continuation,
    Yield
  }

  alias Kadena.Types.{PactTransactionHash, Step}

  @behaviour Kadena.Chainweb.Resource

  @type pact_id :: PactTransactionHash.t()
  @type step :: Step.t()
  @type step_count :: integer()
  @type executed :: boolean() | nil
  @type step_has_rollback :: boolean()
  @type continuation :: Continuation.t()
  @type yield :: Yield.t() | nil

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

  @mapping [
    pact_id: {:struct, PactTransactionHash},
    step: {:struct, Step},
    continuation: {:struct, Continuation},
    yield: {:struct, Yield}
  ]

  @impl true
  def new(attrs) do
    %__MODULE__{}
    |> Mapping.build(attrs)
    |> Mapping.parse(@mapping)
  end
end
