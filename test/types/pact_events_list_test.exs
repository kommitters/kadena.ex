defmodule Kadena.Types.PactEventsListTest do
  @moduledoc """
  `PactEventsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{PactEvent, PactEventsList}

  describe "new/1" do
    setup do
      module_value = [name: "coin", name_space: nil]
      params_value = ["account1", "account2", 0.00005]

      pact_event_value = [
        name: "TRANSFER",
        module: module_value,
        params: params_value,
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
      ]

      %{
        pact_event_value: pact_event_value,
        pact_event: PactEvent.new(pact_event_value)
      }
    end

    test "with valid pact event value", %{
      pact_event_value: pact_event_value,
      pact_event: pact_event
    } do
      %PactEventsList{pact_events: [^pact_event]} = PactEventsList.new([pact_event_value])
    end

    test "with valid pact event struct", %{pact_event: pact_event} do
      %PactEventsList{pact_events: [^pact_event]} = PactEventsList.new([pact_event])
    end

    test "with valid params and empty list" do
      %PactEventsList{pact_events: []} = PactEventsList.new([])
    end

    test "with invalid pact_events list", %{pact_event: pact_event} do
      {:error, [pact_events: :invalid, name: :invalid]} =
        PactEventsList.new([pact_event] ++ [["invalid_pact_event"]])
    end

    test "with invalid list" do
      {:error, [pact_events: :invalid_type]} = PactEventsList.new("invalid_pact_events_list")
    end
  end
end
