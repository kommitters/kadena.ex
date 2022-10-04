defmodule Kadena.Types.PactEventTest do
  @moduledoc """
  `PactEvent` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactEvent, PactEventModule, PactValuesList}

  describe "new/1" do
    setup do
      module_value = [name: "coin", name_space: nil]
      params_value = ["account1", "account2", 0.00005]

      %{
        name: "TRANSFER",
        module: module_value,
        module_struct: PactEventModule.new(module_value),
        params: params_value,
        params_struct: PactValuesList.new(params_value),
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
      }
    end

    test "with valid arguments", %{
      name: name,
      module: module,
      module_struct: module_struct,
      params: params,
      params_struct: params_struct,
      module_hash: module_hash
    } do
      %PactEvent{
        name: ^name,
        module: ^module_struct,
        params: ^params_struct,
        module_hash: ^module_hash
      } =
        PactEvent.new(
          name: name,
          module: module,
          params: params,
          module_hash: module_hash
        )
    end

    test "with valid PactValuesList and PactEventModule structs", %{
      name: name,
      module_struct: module_struct,
      params_struct: params_struct,
      module_hash: module_hash
    } do
      %PactEvent{
        name: ^name,
        module: ^module_struct,
        params: ^params_struct,
        module_hash: ^module_hash
      } =
        PactEvent.new(
          name: name,
          module: module_struct,
          params: params_struct,
          module_hash: module_hash
        )
    end

    test "with invalid name", %{
      module: module,
      params: params,
      module_hash: module_hash
    } do
      {:error, [name: :invalid]} =
        PactEvent.new(
          name: :invalid_name,
          module: module,
          params: params,
          module_hash: module_hash
        )
    end

    test "with invalid module", %{
      name: name,
      params: params,
      module_hash: module_hash
    } do
      {:error, [module: :invalid]} =
        PactEvent.new(
          name: name,
          module: "invalid_module",
          params: params,
          module_hash: module_hash
        )
    end

    test "with invalid module list", %{
      name: name,
      params: params,
      module_hash: module_hash
    } do
      {:error, [module: :invalid, name: :invalid]} =
        PactEvent.new(
          name: name,
          module: [name: 1, name_space: "free"],
          params: params,
          module_hash: module_hash
        )
    end

    test "with invalid params", %{
      name: name,
      module: module,
      module_hash: module_hash
    } do
      {:error, [params: :invalid]} =
        PactEvent.new(
          name: name,
          module: module,
          params: "invalid_params",
          module_hash: module_hash
        )
    end

    test "with invalid params list", %{
      name: name,
      module: module,
      module_hash: module_hash
    } do
      {:error, [params: :invalid, pact_values: :invalid]} =
        PactEvent.new(
          name: name,
          module: module,
          params: ["account1", :account2, 0.00005],
          module_hash: module_hash
        )
    end

    test "with an invalid module_hash", %{
      name: name,
      module: module,
      params: params
    } do
      {:error, [module_hash: :invalid]} =
        PactEvent.new(
          name: name,
          module: module,
          params: params,
          module_hash: 123
        )
    end
  end
end
