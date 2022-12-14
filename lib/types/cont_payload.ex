defmodule Kadena.Types.ContPayload do
  @moduledoc """
  `ContPayload` struct definition.
  """

  alias Kadena.Types.{EnvData, PactTransactionHash, Proof, Rollback, Step}

  @behaviour Kadena.Types.Spec

  @type data :: EnvData.t() | nil
  @type pact_id :: PactTransactionHash.t()
  @type proof :: Proof.t() | nil
  @type rollback :: Rollback.t()
  @type step :: Step.t()
  @type str :: String.t()
  @type value :: data() | pact_id() | proof() | rollback() | step()
  @type validation :: {:ok, value()} | {:error, Keyword.t()}

  @type t :: %__MODULE__{
          data: data(),
          pact_id: pact_id(),
          proof: proof(),
          rollback: rollback(),
          step: step()
        }

  defstruct [:data, :pact_id, :proof, :rollback, :step]

  @impl true
  def new(args) do
    data = Keyword.get(args, :data)
    pact_id = Keyword.get(args, :pact_id)
    proof = Keyword.get(args, :proof)
    rollback = Keyword.get(args, :rollback)
    step = Keyword.get(args, :step)

    with {:ok, data} <- validate_data(data),
         {:ok, pact_id} <- validate_pact_id(pact_id),
         {:ok, proof} <- validate_proof(proof),
         {:ok, rollback} <- validate_rollback(rollback),
         {:ok, step} <- validate_step(step) do
      %__MODULE__{data: data, pact_id: pact_id, step: step, proof: proof, rollback: rollback}
    end
  end

  @spec validate_data(data :: map()) :: validation()
  defp validate_data(nil), do: {:ok, nil}
  defp validate_data(%EnvData{} = data), do: {:ok, data}

  defp validate_data(data) do
    case EnvData.new(data) do
      %EnvData{} = data -> {:ok, data}
      _error -> {:error, [data: :invalid]}
    end
  end

  @spec validate_pact_id(pact_id :: str()) :: validation()
  defp validate_pact_id(pact_id) do
    case PactTransactionHash.new(pact_id) do
      %PactTransactionHash{} = pact_id -> {:ok, pact_id}
      _error -> {:error, [pact_id: :invalid]}
    end
  end

  @spec validate_proof(proof :: str()) :: validation()
  defp validate_proof(nil), do: {:ok, nil}

  defp validate_proof(proof) do
    case Proof.new(proof) do
      %Proof{} = proof -> {:ok, proof}
      _error -> {:error, [proof: :invalid]}
    end
  end

  @spec validate_rollback(rollback :: boolean()) :: validation()
  defp validate_rollback(rollback) do
    case Rollback.new(rollback) do
      %Rollback{} = rollback -> {:ok, rollback}
      _error -> {:error, [rollback: :invalid]}
    end
  end

  @spec validate_step(step :: integer()) :: validation()
  defp validate_step(step) do
    case Step.new(step) do
      %Step{} = step -> {:ok, step}
      _error -> {:error, [step: :invalid]}
    end
  end
end
