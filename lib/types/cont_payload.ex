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
  @type validation :: {:ok, any()} | {:error, atom()}
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

  @spec validate_data(data :: data()) :: validation()
  defp validate_data(%EnvData{} = data), do: {:ok, data}
  defp validate_data(nil), do: {:ok, nil}
  defp validate_data(_data), do: {:error, [:data, :invalid]}

  @spec validate_pact_id(pact_id :: pact_id()) :: validation()
  defp validate_pact_id(%PactTransactionHash{} = pact_id), do: {:ok, pact_id}
  defp validate_pact_id(_pact_id), do: {:error, [:pact_id, :invalid]}

  @spec validate_proof(proof :: proof()) :: validation()
  defp validate_proof(%Proof{} = proof), do: {:ok, proof}
  defp validate_proof(nil), do: {:ok, nil}
  defp validate_proof(_proof), do: {:error, [:proof, :invalid]}

  @spec validate_rollback(rollback :: rollback()) :: validation()
  defp validate_rollback(%Rollback{} = rollback), do: {:ok, rollback}
  defp validate_rollback(_rollback), do: {:error, [:rollback, :invalid]}

  @spec validate_step(step :: step()) :: validation()
  defp validate_step(%Step{} = step), do: {:ok, step}
  defp validate_step(_step), do: {:error, [:step, :invalid]}
end
