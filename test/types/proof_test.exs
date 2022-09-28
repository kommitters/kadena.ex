defmodule Kadena.Types.ProofTest do
  @moduledoc """
  `Proof` struct definition tests.
  """

  alias Kadena.Types.Proof

  use ExUnit.Case

  describe "new/1" do
    test "with a valid value" do
      %Proof{value: "valid_proof"} = Proof.new("valid_proof")
    end

    test "with a nil value" do
      %Proof{value: nil} = Proof.new(nil)
    end

    test "with an invalid atom" do
      {:error, [value: :invalid]} = Proof.new(:proof)
    end
  end
end
