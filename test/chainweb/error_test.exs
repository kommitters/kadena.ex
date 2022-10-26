defmodule Kadena.Chainweb.ErrorTest do
  @moduledoc """
  `Chainweb.Error` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Error

  describe "new/1" do
    test "with a chainweb error" do
      %Error{status: 400, title: "not enough input"} =
        Error.new({:chainweb, %{status: 400, title: "not enough input"}})
    end

    test "with a network error" do
      %Error{status: :network_error, title: :timeout} = Error.new({:network, :timeout})
    end
  end
end
