defmodule Kadena.Types.StepTest do
  @moduledoc """
  `Step` struct definition tests.
  """

  alias Kadena.Types.Step

  use ExUnit.Case

  describe "new/1" do
    test "with a valid step number" do
      %Step{number: 2} = Step.new(2)
    end

    test "with an invalid step" do
      {:error, :invalid_step} = Step.new("2")
    end

    test "with a nil step value" do
      {:error, :invalid_step} = Step.new(nil)
    end
  end
end
