defmodule Kadena.Pact.DefaultExpTest do
  @moduledoc """
  `Pact.Exp.Default` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.Exp

  describe "create_meta/6" do
    test "with valid args" do
      {:ok, "(+ 2 3)"} = Exp.create_exp(["+", 2, 3])
    end

    test "with an invalid no list args" do
      {:error, [args: :not_a_list]} = Exp.create_exp("+")
    end
  end
end
