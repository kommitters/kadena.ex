defmodule Kadena.Types.SignaturesListTest do
  @moduledoc """
  `SignaturesList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignaturesList}

  describe "new/1" do
    test "with a valid list" do
      signature1 = "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d"

      signature2 =
        Signature.new(
          "8c8932a6459945afb87dbce6f625d07d4bbaafcc01f570b279d41a3d0f51f18ac5f05c017581aab23459e0437b4715774dea80a67da41f3b1b3988b2d59c3c0a"
        )

      signatures = [
        signature1,
        signature2
      ]

      %SignaturesList{signatures: [%Signature{sig: ^signature1}, ^signature2]} =
        SignaturesList.new(signatures)
    end

    test "with an empty list value" do
      %SignaturesList{signatures: []} = SignaturesList.new([])
    end

    test "with a nil value" do
      {:error, [signatures: :not_a_list]} = SignaturesList.new(nil)
    end

    test "with an atom value" do
      {:error, [signatures: :not_a_list]} = SignaturesList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [signatures: :invalid, sig: :invalid]} = SignaturesList.new([nil])
    end

    test "when the list has invalid values" do
      signatures = [
        "ba54b224d1924dd98403f5c751abdd10de6cd81b0121800bf7bdbdcfaec7388d",
        "8c8932a6459945afb87dbce6f625d07d4bbaafcc01f570b279d41a3d0f51f18ac5f05c017581aab23459e0437b4715774dea80a67da41f3b1b3988b2d59c3c0a"
      ]

      {:error, [signatures: :invalid, sig: :invalid]} = SignaturesList.new(signatures ++ [nil])
    end
  end
end
