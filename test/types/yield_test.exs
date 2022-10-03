defmodule Kadena.Types.YieldTest do
  @moduledoc """
  `Yield` struct definition tests.
  """

  alias Kadena.Types.{Provenance, Yield}

  use ExUnit.Case

  describe "new/1" do
    setup do
      data = %{
        amount: 0.01,
        receiver: "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc",
        source_chain: 0,
        receiver_guard: [
          pred: "keys-all",
          keys: [
            "4f9c46df2fe874d7c1b60f68f8440a444dd716e6b2efba8ee141afdd58c993dc"
          ]
        ]
      }

      provenance = [
        target_chain_id: "1",
        module_hash: "rE7DU8jlQL9x_MPYuniZJf5ICBTAEHAIFQCB4blofP4"
      ]

      provenance_struct = Provenance.new(provenance)

      %{
        data: data,
        provenance: provenance,
        provenance_struct: provenance_struct
      }
    end

    test "with valid args", %{
      data: data,
      provenance: provenance,
      provenance_struct: provenance_struct
    } do
      %Yield{
        data: ^data,
        provenance: ^provenance_struct
      } =
        Yield.new(
          data: data,
          provenance: provenance
        )
    end

    test "with a valid Provenance struct", %{
      data: data,
      provenance_struct: provenance_struct
    } do
      %Yield{
        data: ^data,
        provenance: ^provenance_struct
      } =
        Yield.new(
          data: data,
          provenance: provenance_struct
        )
    end

    test "with a valid nil provenance", %{data: data} do
      %Yield{data: ^data, provenance: nil} =
        Yield.new(
          data: data,
          provenance: nil
        )
    end

    test "with an invalid data", %{provenance: provenance} do
      {:error, [data: :invalid]} =
        Yield.new(
          data: "invalid_data",
          provenance: provenance
        )
    end

    test "with an invalid provenance list of nil", %{data: data} do
      {:error, [provenance: :invalid]} =
        Yield.new(
          data: data,
          provenance: [nil]
        )
    end

    test "with an invalid empty list" do
      {:error, [data: :invalid]} = Yield.new([])
    end
  end
end
