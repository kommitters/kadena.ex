defmodule Kadena.Types.SignatureTest do
  @moduledoc """
  `Signature` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Signature

  describe "new/1" do
    test "with a valid sig" do
      %Signature{sig: "valid_signature"} = Signature.new("valid_signature")
    end

    test "with a nil sig" do
      %Signature{sig: nil} = Signature.new(nil)
    end

    test "with an atom value" do
      {:error, :invalid_signature} = Signature.new(:signature)
    end

    test "with a numeric value" do
      {:error, :invalid_signature} = Signature.new(123)
    end

    test "with an empty list value" do
      {:error, :invalid_signature} = Signature.new([])
    end
  end
end
