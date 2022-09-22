defmodule Kadena.Types.EnvDataTest do
  @moduledoc """
  `EnvData` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.EnvData

  describe "new/1" do
    test "with valid env data" do
      %EnvData{data: %{}} = EnvData.new(%{})
    end

    test "with nil env data" do
      {:error, :invalid_env_data} = EnvData.new(nil)
    end

    test "with number env data" do
      {:error, :invalid_env_data} = EnvData.new(12345)
    end

    test "with atom env data" do
      {:error, :invalid_env_data} = EnvData.new(:atom)
    end
  end
end
