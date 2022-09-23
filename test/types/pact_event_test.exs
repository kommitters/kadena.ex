defmodule Kadena.Types.PactEventTest do
  @moduledoc """
  `PactEvent` struct definition tests.
  """

  alias Kadena.Types.PactEvent

  use ExUnit.Case

  describe "new/1" do
    test "with a valid list of values" do
      %PactEvent{
        name: "TRANSFER",
        module: %{
          name: "coin",
          namespace: null
        },
        params: [
          "k:2e1fc8dd2c46700a508c2cc7503f0c854be1cec501f9da37f4d32c53762c66fb",
          "k:2fb817bd6b93b690963c78b957d812fca4bb0a4a0071777c9a3cf32664a5995f",
          0.00005
        ],
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
      } =
        PactEvent.new(
          name: "TRANSFER",
          module: %{
            name: "coin",
            namespace: null
          },
          params: [
            "k:2e1fc8dd2c46700a508c2cc7503f0c854be1cec501f9da37f4d32c53762c66fb",
            "k:2fb817bd6b93b690963c78b957d812fca4bb0a4a0071777c9a3cf32664a5995f",
            0.00005
          ],
          module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
        )
    end
  end
end
