defmodule Kadena.Pact.ExpTest do
  @moduledoc """
  `Pact.Exp` functions tests.
  """

  use ExUnit.Case

  alias Kadena.Pact.Exp

  describe "create/1" do
    test "with valid args" do
      {:ok, "(+ 2 3)"} = Exp.create(["+", 2, 3])
    end

    test "with an invalid no list args" do
      {:error, [args: :not_a_list]} = Exp.create("+")
    end
  end
end
