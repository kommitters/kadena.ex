defmodule Kadena.Types.SignaturesListTest do
  @moduledoc """
  `SignaturesList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{Signature, SignaturesList}

  describe "new/1" do
    test "with a valid list" do
      signature1 = Signature.new("valid signature1")
      signature2 = Signature.new("valid signature2")

      %SignaturesList{list: [^signature2, ^signature1]} =
        SignaturesList.new([signature1, signature2])
    end

    test "with an empty list value" do
      %SignaturesList{list: []} = SignaturesList.new([])
    end

    test "with a nil value" do
      {:error, :invalid_signature} = SignaturesList.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_signature} = SignaturesList.new(:atom)
    end

    test "with a list of nil" do
      {:error, :invalid_signature} = SignaturesList.new([nil])
    end

    test "when the list has invalid values" do
      signature1 = Signature.new("valid signature1")
      signature2 = Signature.new("valid signature2")
      {:error, :invalid_signature} = SignaturesList.new([signature1, nil, signature2])
    end
  end
end
