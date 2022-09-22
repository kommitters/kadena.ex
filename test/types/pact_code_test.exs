defmodule Kadena.Types.PactCodeTest do
  @moduledoc """
  `PactCode` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.PactCode

  describe "new/1" do
    test "with a valid pact code" do
      %PactCode{code: "(format \"hello {}\" [\"world\"])"} = PactCode.new("(format \"hello {}\" [\"world\"])")
    end

    test "with a number pact code" do
      {:error, :invalid_pact_code} = PactCode.new(12345)
    end

    test "with a atom pact code" do
      {:error, :invalid_pact_code} = PactCode.new(:atom)
    end

    test "with a nil pact code" do
      {:error, :invalid_pact_code} = PactCode.new(nil)
    end
  end
end
