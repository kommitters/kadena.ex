defmodule Kadena.Chainweb.Pact.Resources.PactEventTest do
  @moduledoc """
  `PactEvent` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactValue, PactValuesList}
  alias Kadena.Chainweb.Pact.Resources.{PactEvent, PactEventModule}

  setup do
    %{
      attrs: %{
        "module" => %{
          "name" => "coin",
          "namespace" => nil
        },
        "module_hash" => "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
        "name" => "TRANSFER",
        "params" => [
          "account1",
          "account2",
          0.00005
        ]
      }
    }
  end

  test "new/1", %{attrs: attrs} do
    decimal = Decimal.new("0.000050")

    %PactEvent{
      module: %PactEventModule{name: "coin", namespace: nil},
      module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4",
      name: "TRANSFER",
      params: %PactValuesList{
        pact_values: [
          %PactValue{literal: "account1"},
          %PactValue{literal: "account2"},
          %PactValue{literal: ^decimal}
        ]
      }
    } = PactEvent.new(attrs)
  end
end
