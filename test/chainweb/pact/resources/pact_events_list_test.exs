defmodule Kadena.Chainweb.Pact.Resources.PactEventsListTest do
  @moduledoc """
  `PactEventsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Chainweb.Pact.Resources.{PactEvent, PactEventsList}

  setup do
    pact_event_1_attrs = %{
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

    pact_event_2_attrs = %{
      "module" => %{
        "name" => "coin",
        "namespace" => nil
      },
      "module_hash" => "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP5",
      "name" => "TRANSFER",
      "params" => [
        "account3",
        "account4",
        0.00005
      ]
    }

    %{
      pact_events: [pact_event_1_attrs, pact_event_2_attrs],
      pact_event_1: PactEvent.new(pact_event_1_attrs),
      pact_event_2: PactEvent.new(pact_event_2_attrs)
    }
  end

  test "new/1", %{
    pact_events: pact_events,
    pact_event_1: pact_event_1,
    pact_event_2: pact_event_2
  } do
    %PactEventsList{
      pact_events: [^pact_event_1, ^pact_event_2]
    } = PactEventsList.new(pact_events)
  end
end
