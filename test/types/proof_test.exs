defmodule Kadena.Types.ProofTest do
  @moduledoc """
  `Proof` struct definition tests.
  """

  alias Kadena.Types.Proof

  use ExUnit.Case

  describe "new/1" do
    test "with a valid url" do
      %Proof{url: "valid_proof"} = Proof.new("valid_proof")
    end

    test "with a nil url" do
      %Proof{url: nil} = Proof.new(nil)
    end

    test "with an invalid atom" do
      {:error, :invalid_proof} = Proof.new(:proof)
    end
  end
end
