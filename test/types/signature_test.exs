defmodule Kadena.Types.SignatureTest do
  @moduledoc """
  `Signature` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Signature

  describe "new/1" do
    test "With valid sig" do
      %Signature{sig: "valid_signature"} = Signature.new("valid_signature")
    end

    test "With nil sig" do
      %Signature{sig: nil} = Signature.new(nil)
    end

    test "With atom value" do
      {:error, :invalid_signature} = Signature.new(:signature)
    end

    test "With numeric value" do
      {:error, :invalid_signature} = Signature.new(123)
    end

    test "With one list item with invalid value" do
      {:error, :invalid_signature} = Signature.new(["sig", nil, true])
    end

    test "With each list item with invalid value" do
      {:error, :invalid_signature} = Signature.new(["sig", nil])
    end

    test "With empty list value" do
      {:error, :invalid_signature} = Signature.new([])
    end
  end
end