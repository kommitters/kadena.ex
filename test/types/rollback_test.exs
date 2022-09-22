defmodule Kadena.Types.RollbackTest do
  @moduledoc """
  `Rollback` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.Rollback

  describe "new/1" do
    test "with a valid true value" do
      %Rollback{value: true} = Rollback.new(true)
    end

    test "with a valid false value" do
      %Rollback{value: false} = Rollback.new(false)
    end

    test "with an invalid value" do
      {:error, :invalid_rollback} = Rollback.new(:atom)
    end

    test "with a nil value" do
      {:error, :invalid_rollback} = Rollback.new(nil)
    end
  end
end
