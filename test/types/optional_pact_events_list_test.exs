defmodule Kadena.Types.OptionalPactEventsListTest do
  @moduledoc """
  `OptionalPactEventsList` struct definition tests.
  """

  use ExUnit.Case

  alias Kadena.Types.{OptionalPactEventsList, PactEvent, PactEventsList}

  describe "new/1" do
    test "with valid pact event list struct" do
      module_value = [name: "coin", name_space: nil]
      params_value = ["account1", "account2", 0.00005]

      pact_event =
        PactEvent.new(
          name: "TRANSFER",
          module: module_value,
          params: params_value,
          module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
        )

      pact_event_list = PactEventsList.new([pact_event])

      %OptionalPactEventsList{pact_events: ^pact_event_list} =
        OptionalPactEventsList.new(pact_event_list)
    end

    test "without setting the args" do
      %OptionalPactEventsList{pact_events: nil} = OptionalPactEventsList.new()
    end

    test "with a nil value" do
      %OptionalPactEventsList{pact_events: nil} = OptionalPactEventsList.new(nil)
    end

    test "with an empty list value" do
      {:error, [pact_events: :invalid]} = OptionalPactEventsList.new([])
    end

    test "with an atom value" do
      {:error, [pact_events: :invalid]} = OptionalPactEventsList.new(:atom)
    end

    test "with a list of nil" do
      {:error, [pact_events: :invalid]} = OptionalPactEventsList.new([nil])
    end
  end
end
